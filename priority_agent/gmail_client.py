"""Gmail API client for creating email drafts.

Creates draft emails in the authenticated user's Gmail account.
"""

import base64
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from googleapiclient.discovery import build

from .auth import get_credentials


def get_gmail_service():
    """Build and return an authenticated Gmail API service."""
    creds = get_credentials()
    return build("gmail", "v1", credentials=creds)


def create_draft(to, subject, body, cc=None):
    """Create a draft email in the user's Gmail account.

    Args:
        to: Recipient email address.
        subject: Email subject line.
        body: Email body text (plain text).
        cc: Optional CC recipient(s), comma-separated string.

    Returns:
        dict: The created draft resource from Gmail API.
    """
    service = get_gmail_service()

    message = MIMEMultipart("alternative")
    message["To"] = to
    message["Subject"] = subject
    if cc:
        message["Cc"] = cc

    # Create both plain text and HTML versions
    text_part = MIMEText(body, "plain")
    html_body = body.replace("\n", "<br>\n")
    html_part = MIMEText(f"<html><body>{html_body}</body></html>", "html")

    message.attach(text_part)
    message.attach(html_part)

    encoded_message = base64.urlsafe_b64encode(message.as_bytes()).decode()

    draft = (
        service.users()
        .drafts()
        .create(
            userId="me",
            body={"message": {"raw": encoded_message}},
        )
        .execute()
    )

    print(f"  Draft created successfully (ID: {draft['id']})")
    return draft


def list_drafts(max_results=5):
    """List recent drafts in the user's Gmail account.

    Args:
        max_results: Maximum number of drafts to return.

    Returns:
        list: List of draft resources.
    """
    service = get_gmail_service()
    results = (
        service.users()
        .drafts()
        .list(userId="me", maxResults=max_results)
        .execute()
    )
    return results.get("drafts", [])
