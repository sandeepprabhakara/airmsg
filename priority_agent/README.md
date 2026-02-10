# Priority Management Agent

Interactive CLI agent that walks through your top priorities and creates Gmail drafts or Google Calendar events for each.

## Setup

### 1. Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select an existing one)
3. Enable these APIs:
   - **Gmail API**: [Enable here](https://console.cloud.google.com/apis/library/gmail.googleapis.com)
   - **Google Calendar API**: [Enable here](https://console.cloud.google.com/apis/library/calendar-json.googleapis.com)

### 2. OAuth2 Credentials

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth 2.0 Client ID**
3. Select **Desktop application** as the application type
4. Download the JSON file
5. Save it as `priority_agent/credentials.json`

### 3. Install Dependencies

```bash
pip install -r priority_agent/requirements.txt
```

### 4. Run the Agent

```bash
python -m priority_agent
```

On first run, a browser window will open for Google OAuth authorization. Sign in with `sandeep.prabhakara@gmail.com` and grant access. The token is saved locally in `token.json` for future sessions.

## Usage

The agent presents each priority one by one. For each, you can:

- **email** — Create a Gmail draft (you fill in recipients, subject, body)
- **calendar** — Create a Google Calendar event (you fill in date, time, attendees)
- **both** — Create both an email draft and a calendar event
- **skip** — Move to the next priority
- **quit** — Exit the agent

At the end, you get a summary of all actions taken.

## File Structure

```
priority_agent/
├── __init__.py          # Package marker
├── __main__.py          # Module entry point
├── agent.py             # Main interactive agent
├── auth.py              # Google OAuth2 authentication
├── calendar_client.py   # Google Calendar API client
├── gmail_client.py      # Gmail API client
├── priorities.py        # Priority definitions
├── credentials.json     # YOUR Google OAuth credentials (not committed)
├── token.json           # Auto-generated auth token (not committed)
├── requirements.txt     # Python dependencies
└── README.md            # This file
```

## Adding/Editing Priorities

Edit `priorities.py` to update the list of priorities the agent processes.
