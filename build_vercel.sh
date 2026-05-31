#!/bin/bash
set -e

echo "--- Installing Flutter (stable) ---"
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
export PATH="$PATH:/tmp/flutter/bin"

flutter config --no-analytics
flutter precache --web
flutter pub get

echo "--- Building Flutter web ---"
if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "ERROR: GEMINI_API_KEY is not set."
  echo "Add GEMINI_API_KEY to your hosting provider's build environment."
  echo "For a local release build, run:"
  echo "  flutter build web --release --dart-define=GEMINI_API_KEY=YOUR_API_KEY"
  exit 1
fi

flutter build web --release \
  --dart-define=GEMINI_API_KEY="${GEMINI_API_KEY}" \
  --dart-define=GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.5-flash}" \
  ${APP_URL:+--dart-define=APP_URL="${APP_URL}"}

echo "--- Build complete ---"
