# FreshRSS Hermes Skill

A [Hermes Agent](https://hermes-agent.nousresearch.com/) skill for managing a self-hosted FreshRSS instance via the Google Reader API.

## Capabilities

- List feeds, categories, and unread counts
- Fetch articles with filtering (by feed, category, unread/starred status)
- Retrieve full article text (HTML-stripped) for summarization
- Mark articles as read/unread
- Star/unstar articles
- Subscribe to and unsubscribe from feeds

## Setup

### 1. Enable FreshRSS API access

In FreshRSS: **Settings > Authentication** → enable "Allow API access", then **Profile > API Management** → set an API password.

### 2. Configure environment variables

Set these in your Hermes environment (e.g., `~/.hermes/.env`):

```
FRESHRSS_URL=https://your-freshrss-instance.example.com
FRESHRSS_USER=your_username
FRESHRSS_API_PASSWORD=your_api_password
```

### 3. Install the skill

Copy the `freshrss/` directory into your Hermes skills folder:

```bash
cp -r freshrss/ ~/.hermes/skills/freshrss/
```

Or for Kubernetes deployments, use the initContainer defined in the deployment manifest (see `Deployment` section below).

## Local testing

```bash
export FRESHRSS_URL=https://your-instance.example.com
export FRESHRSS_USER=your_user
export FRESHRSS_API_PASSWORD=your_api_password

python3 freshrss/scripts/freshrss.py list-feeds
python3 freshrss/scripts/freshrss.py unread-counts
python3 freshrss/scripts/freshrss.py articles --unread-only --count 5
python3 freshrss/scripts/freshrss.py article-content "<article_id>" --text
```

## Deployment (Kubernetes)

For the homelab K8s deployment:

1. Create secrets in Bitwarden Secrets Manager for `FRESHRSS_URL`, `FRESHRSS_USER`, `FRESHRSS_API_PASSWORD`
2. Update `bitwarden-secret.yaml` with the real secret IDs (replace `PLACEHOLDER_*` values)
3. Push this repo to GitHub
4. The Hermes deployment initContainer will clone the skill on pod startup

## Requirements

- Python 3.8+ (stdlib only, no pip dependencies)
- FreshRSS with API access enabled
