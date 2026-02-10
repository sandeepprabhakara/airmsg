"""Google Calendar API client for creating events.

Creates calendar events in the authenticated user's Google Calendar.
"""

from datetime import datetime, timedelta

from dateutil import parser as date_parser
from googleapiclient.discovery import build

from .auth import get_credentials


def get_calendar_service():
    """Build and return an authenticated Google Calendar API service."""
    creds = get_credentials()
    return build("calendar", "v3", credentials=creds)


def create_event(
    summary,
    description="",
    start_time=None,
    end_time=None,
    date_str=None,
    duration_minutes=60,
    attendees=None,
    timezone="America/New_York",
):
    """Create a calendar event in the user's Google Calendar.

    Args:
        summary: Event title.
        description: Event description/notes.
        start_time: datetime object for event start. If None, uses date_str.
        end_time: datetime object for event end. If None, calculated from duration.
        date_str: String date/time to parse (e.g. "2026-02-20 10:00 AM").
        duration_minutes: Duration in minutes (default 60).
        attendees: List of email addresses to invite.
        timezone: Timezone string (default America/New_York).

    Returns:
        dict: The created event resource from Calendar API.
    """
    service = get_calendar_service()

    # Parse start time
    if start_time is None and date_str:
        try:
            start_time = date_parser.parse(date_str)
        except (ValueError, TypeError):
            print(f"  Could not parse date: {date_str}")
            print("  Using tomorrow at 10:00 AM as default.")
            start_time = datetime.now().replace(
                hour=10, minute=0, second=0, microsecond=0
            ) + timedelta(days=1)
    elif start_time is None:
        start_time = datetime.now().replace(
            hour=10, minute=0, second=0, microsecond=0
        ) + timedelta(days=1)

    # Calculate end time
    if end_time is None:
        end_time = start_time + timedelta(minutes=duration_minutes)

    event_body = {
        "summary": summary,
        "description": description,
        "start": {
            "dateTime": start_time.isoformat(),
            "timeZone": timezone,
        },
        "end": {
            "dateTime": end_time.isoformat(),
            "timeZone": timezone,
        },
        "reminders": {
            "useDefault": False,
            "overrides": [
                {"method": "email", "minutes": 24 * 60},
                {"method": "popup", "minutes": 30},
            ],
        },
    }

    if attendees:
        event_body["attendees"] = [{"email": email.strip()} for email in attendees]
        # Send notifications to attendees
        event_body["guestsCanModify"] = False

    event = (
        service.events()
        .insert(
            calendarId="primary",
            body=event_body,
            sendUpdates="all" if attendees else "none",
        )
        .execute()
    )

    print(f"  Event created: {event.get('htmlLink', 'OK')}")
    return event


def list_upcoming_events(max_results=10):
    """List upcoming events from the user's Google Calendar.

    Args:
        max_results: Maximum number of events to return.

    Returns:
        list: List of event resources.
    """
    service = get_calendar_service()
    now = datetime.utcnow().isoformat() + "Z"

    events_result = (
        service.events()
        .list(
            calendarId="primary",
            timeMin=now,
            maxResults=max_results,
            singleEvents=True,
            orderBy="startTime",
        )
        .execute()
    )
    return events_result.get("items", [])
