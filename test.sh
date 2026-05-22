#!/usr/bin/env bash
# Quick smoke test for the FreshRSS skill against a live instance.
# Sources .env for credentials, runs read-only commands only.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in credentials."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

if [ -z "${FRESHRSS_API_PASSWORD:-}" ]; then
  echo "ERROR: FRESHRSS_API_PASSWORD is empty in .env. Set it before running tests."
  exit 1
fi

PY="python3 $SCRIPT_DIR/freshrss/scripts/freshrss.py"

echo "=== Test 1: list-feeds ==="
$PY list-feeds | python3 -m json.tool | head -30
echo

echo "=== Test 2: list-categories ==="
$PY list-categories | python3 -m json.tool
echo

echo "=== Test 3: unread-counts ==="
$PY unread-counts | python3 -m json.tool | head -40
echo

echo "=== Test 4: articles (unread, 3 items) ==="
ARTICLES=$($PY articles --unread-only --count 3)
echo "$ARTICLES" | python3 -m json.tool | head -50
echo

# Grab the first article ID for content test
FIRST_ID=$(echo "$ARTICLES" | python3 -c "import sys,json; items=json.load(sys.stdin).get('items',[]); print(items[0]['id'] if items else '')" 2>/dev/null)

if [ -n "$FIRST_ID" ]; then
  echo "=== Test 5: article-content (text mode) ==="
  $PY article-content "$FIRST_ID" --text | head -30
  echo
  echo "..."
else
  echo "=== Test 5: SKIPPED (no unread articles) ==="
fi

echo
echo "All read-only tests passed."
