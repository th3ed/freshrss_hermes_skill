# AGENTS.md

## Project

Hermes Agent skill for managing a self-hosted FreshRSS instance via the Google Reader API.

## Structure

- `freshrss/scripts/freshrss.py` — single-file CLI entrypoint (stdlib only)
- `freshrss/SKILL.md` — Hermes skill manifest and command reference
- `test.sh` — smoke test against a live FreshRSS instance

## Dependencies

- Python 3.8+
- **Stdlib only.** No `requirements.txt`, `pyproject.toml`, or pip install step.

## Running

```bash
python3 freshrss/scripts/freshrss.py <command> [options]
```

Common commands: `list-feeds`, `articles`, `article-content`, `mark-read`, `add-feed`.
See `freshrss/SKILL.md` for full command reference and workflow examples.

## Testing

`./test.sh` sources `.env` and runs read-only smoke tests against a live instance.

Prerequisites:
- `.env` file in repo root with `FRESHRSS_URL`, `FRESHRSS_USER`, `FRESHRSS_API_PASSWORD`
- The FreshRSS instance must have API access enabled

There is no unit test suite or CI pipeline.

## Important conventions

- **Always confirm mutations with the user.** Never run `add-feed`, `remove-feed`, `mark-all-read`, or write commands without explicit approval. This is enforced by convention, not code.
- Article IDs are long strings (e.g. `tag:google.com,2005:reader/item/0000001234abcdef`). Always quote them.
- The script caches auth tokens in `/tmp/freshrss_cache/`. If auth fails, clear that directory and retry.
- No build, lint, or typecheck steps exist. Changes are verified by running the script or `test.sh`.
