#!/usr/bin/env python3
"""Priority Management Agent.

Interactive CLI agent that walks through each priority item,
asks what action to take, and executes it via Gmail or Google Calendar.

Usage:
    python -m priority_agent.agent
"""

import sys
import textwrap
from datetime import datetime

from .priorities import PRIORITIES
from .gmail_client import create_draft
from .calendar_client import create_event

USER_EMAIL = "sandeep.prabhakara@gmail.com"

DIVIDER = "=" * 65
THIN_DIVIDER = "-" * 65


def print_banner():
    print()
    print(DIVIDER)
    print("  PRIORITY MANAGEMENT AGENT")
    print(f"  Connected account: {USER_EMAIL}")
    print(f"  Date: {datetime.now().strftime('%B %d, %Y')}")
    print(DIVIDER)
    print()
    print("I'll walk you through each of your top priorities.")
    print("For each one, tell me what you'd like to do:")
    print()
    print("  - 'email' or 'draft'  → Create an email draft")
    print("  - 'calendar' or 'meeting' → Create a calendar event")
    print("  - 'both' → Create both an email and a calendar event")
    print("  - 'skip' → Move to the next priority")
    print("  - 'quit' → Exit the agent")
    print()


def print_priority(priority):
    print(THIN_DIVIDER)
    print(f"  Priority #{priority['id']}: {priority['title']}")
    print(f"  Owners: {', '.join(priority['owners'])}")
    print(f"  Timeframe: {priority['timeframe']}")
    print(THIN_DIVIDER)


def get_action():
    """Ask the user what action to take for the current priority."""
    while True:
        action = input("\nWhat would you like to do? (email/calendar/both/skip/quit): ").strip().lower()
        if action in ("email", "draft", "e"):
            return "email"
        elif action in ("calendar", "meeting", "cal", "c", "m"):
            return "calendar"
        elif action in ("both", "b"):
            return "both"
        elif action in ("skip", "s", "next", "n"):
            return "skip"
        elif action in ("quit", "q", "exit"):
            return "quit"
        else:
            print("  Please enter: email, calendar, both, skip, or quit")


def gather_email_details(priority):
    """Gather details for creating an email draft."""
    print()
    print("  --- Email Draft Details ---")

    default_to = USER_EMAIL
    to = input(f"  To [{default_to}]: ").strip() or default_to

    cc = input("  CC (comma-separated emails, or press Enter to skip): ").strip() or None

    default_subject = f"Action Required: {priority['title']}"
    subject = input(f"  Subject [{default_subject}]: ").strip() or default_subject

    print("  Body (type your message, press Enter twice to finish):")
    lines = []
    empty_count = 0
    while True:
        line = input("  > ")
        if line == "":
            empty_count += 1
            if empty_count >= 2:
                break
            lines.append("")
        else:
            empty_count = 0
            lines.append(line)

    body = "\n".join(lines).strip()

    if not body:
        owners_str = ", ".join(priority["owners"])
        body = (
            f"Hi,\n\n"
            f"This is regarding: {priority['title']}\n\n"
            f"Owners: {owners_str}\n"
            f"Timeframe: {priority['timeframe']}\n\n"
            f"Please review and take the necessary action.\n\n"
            f"Best regards"
        )
        print(f"\n  (Using default body since none was provided)")

    return to, cc, subject, body


def gather_calendar_details(priority):
    """Gather details for creating a calendar event."""
    print()
    print("  --- Calendar Event Details ---")

    default_title = priority["title"]
    title = input(f"  Event title [{default_title}]: ").strip() or default_title

    date_str = input("  Date and time (e.g. '2026-02-20 10:00 AM'): ").strip()
    if not date_str:
        print("  (No date provided, will default to tomorrow at 10:00 AM)")

    default_duration = "60"
    duration_str = input(f"  Duration in minutes [{default_duration}]: ").strip() or default_duration
    try:
        duration = int(duration_str)
    except ValueError:
        duration = 60
        print(f"  (Invalid duration, using {duration} minutes)")

    attendees_str = input("  Attendees (comma-separated emails, or press Enter to skip): ").strip()
    attendees = [e.strip() for e in attendees_str.split(",") if e.strip()] if attendees_str else None

    description = input("  Description/notes (or press Enter for default): ").strip()
    if not description:
        owners_str = ", ".join(priority["owners"])
        description = (
            f"Priority: {priority['title']}\n"
            f"Owners: {owners_str}\n"
            f"Category: {priority['category']}\n"
            f"Timeframe: {priority['timeframe']}"
        )

    return title, date_str, duration, attendees, description


def process_email(priority):
    """Create an email draft for a priority."""
    to, cc, subject, body = gather_email_details(priority)

    print(f"\n  Creating draft email...")
    print(f"    To: {to}")
    if cc:
        print(f"    CC: {cc}")
    print(f"    Subject: {subject}")
    print(f"    Body preview: {body[:80]}...")

    confirm = input("\n  Confirm creation? (y/n): ").strip().lower()
    if confirm in ("y", "yes", ""):
        try:
            draft = create_draft(to=to, subject=subject, body=body, cc=cc)
            print(f"  Email draft created in your Gmail!")
        except Exception as e:
            print(f"  Error creating draft: {e}")
    else:
        print("  Skipped email draft creation.")


def process_calendar(priority):
    """Create a calendar event for a priority."""
    title, date_str, duration, attendees, description = gather_calendar_details(priority)

    print(f"\n  Creating calendar event...")
    print(f"    Title: {title}")
    print(f"    Date/Time: {date_str or 'Tomorrow 10:00 AM'}")
    print(f"    Duration: {duration} minutes")
    if attendees:
        print(f"    Attendees: {', '.join(attendees)}")

    confirm = input("\n  Confirm creation? (y/n): ").strip().lower()
    if confirm in ("y", "yes", ""):
        try:
            event = create_event(
                summary=title,
                description=description,
                date_str=date_str if date_str else None,
                duration_minutes=duration,
                attendees=attendees,
            )
            print(f"  Calendar event created!")
        except Exception as e:
            print(f"  Error creating event: {e}")
    else:
        print("  Skipped calendar event creation.")


def run_agent():
    """Main agent loop: iterate through priorities and process actions."""
    print_banner()

    actions_taken = []

    for priority in PRIORITIES:
        print_priority(priority)
        action = get_action()

        if action == "quit":
            print("\nExiting agent. Goodbye!")
            break
        elif action == "skip":
            print("  Skipping this priority.\n")
            actions_taken.append((priority["id"], "skipped"))
            continue
        elif action == "email":
            process_email(priority)
            actions_taken.append((priority["id"], "email draft"))
        elif action == "calendar":
            process_calendar(priority)
            actions_taken.append((priority["id"], "calendar event"))
        elif action == "both":
            process_email(priority)
            process_calendar(priority)
            actions_taken.append((priority["id"], "email + calendar"))

        print()

    # Summary
    print()
    print(DIVIDER)
    print("  SESSION SUMMARY")
    print(DIVIDER)
    if actions_taken:
        for pid, action in actions_taken:
            p = next(p for p in PRIORITIES if p["id"] == pid)
            print(f"  #{pid}: {p['title'][:50]}...")
            print(f"       Action: {action}")
    else:
        print("  No actions taken.")
    print(DIVIDER)
    print()


def main():
    try:
        run_agent()
    except KeyboardInterrupt:
        print("\n\nAgent interrupted. Goodbye!")
        sys.exit(0)
    except Exception as e:
        print(f"\nError: {e}")
        print("Make sure you have set up Google API credentials.")
        print("See: priority_agent/README.md for setup instructions.")
        sys.exit(1)


if __name__ == "__main__":
    main()
