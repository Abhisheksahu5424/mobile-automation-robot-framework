#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p Output

if ! pgrep -f 'appium server -p 4723' >/dev/null 2>&1; then
  echo "Starting Appium..."
  ./start_appium.sh
else
  echo "Appium is already running on port 4723."
fi

echo "Running Robot Framework test..."
robot -d Output --loglevel INFO Tests/Open_Application.robot
