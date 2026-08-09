#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_HOME="${ANDROID_HOME:-/home/abhishek/Android/Sdk}"
ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
export ANDROID_HOME ANDROID_SDK_ROOT
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

if ! command -v appium >/dev/null 2>&1; then
  echo "Appium is not installed or not on PATH." >&2
  exit 1
fi

if pgrep -f 'appium server -p 4723' >/dev/null 2>&1; then
  echo "Appium is already running on port 4723."
  exit 0
fi

mkdir -p "$ROOT_DIR/Output"
nohup appium server -p 4723 --address 127.0.0.1 --base-path /wd/hub >"$ROOT_DIR/Output/appium.log" 2>&1 &
APP_PID=$!
echo "Started Appium with PID $APP_PID"

for _ in {1..10}; do
  if curl -s http://127.0.0.1:4723/wd/hub/status >/dev/null 2>&1; then
    echo "Appium is ready."
    exit 0
  fi
  sleep 1
done

echo "Appium did not become ready in time. Check $ROOT_DIR/Output/appium.log" >&2
exit 1
