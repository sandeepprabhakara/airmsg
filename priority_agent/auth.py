"""Google OAuth2 authentication module.

Handles OAuth2 flow for Gmail and Google Calendar APIs.
Stores credentials locally for reuse across sessions.
"""

import os
import json
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow

# Scopes required for Gmail draft creation and Calendar event management
SCOPES = [
    "https://www.googleapis.com/auth/gmail.compose",
    "https://www.googleapis.com/auth/calendar",
]

TOKEN_PATH = os.path.join(os.path.dirname(__file__), "token.json")
CREDENTIALS_PATH = os.path.join(os.path.dirname(__file__), "credentials.json")


def get_credentials():
    """Obtain valid Google OAuth2 credentials.

    Attempts to load existing credentials from token.json.
    If expired, refreshes them. If missing, initiates the OAuth2 flow.

    Returns:
        google.oauth2.credentials.Credentials: Valid credentials.
    """
    creds = None

    if os.path.exists(TOKEN_PATH):
        creds = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists(CREDENTIALS_PATH):
                print("\n" + "=" * 60)
                print("SETUP REQUIRED: Google API Credentials")
                print("=" * 60)
                print()
                print("To connect to your Gmail and Google Calendar, you need")
                print("to set up a Google Cloud project with OAuth2 credentials.")
                print()
                print("Steps:")
                print("1. Go to https://console.cloud.google.com/")
                print("2. Create a new project (or select existing)")
                print("3. Enable the Gmail API and Google Calendar API")
                print("4. Go to 'APIs & Services' > 'Credentials'")
                print("5. Create OAuth 2.0 Client ID (Desktop application)")
                print("6. Download the credentials JSON file")
                print(f"7. Save it as: {CREDENTIALS_PATH}")
                print()
                print("=" * 60)
                raise FileNotFoundError(
                    f"Missing {CREDENTIALS_PATH}. See instructions above."
                )

            flow = InstalledAppFlow.from_client_secrets_file(
                CREDENTIALS_PATH, SCOPES
            )
            creds = flow.run_local_server(port=0)

        with open(TOKEN_PATH, "w") as token_file:
            token_file.write(creds.to_json())

    return creds
