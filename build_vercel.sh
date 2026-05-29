#!/bin/bash
set -e

echo "--- Installing Flutter (stable) ---"
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
export PATH="$PATH:/tmp/flutter/bin"

flutter config --no-analytics
flutter precache --web
flutter pub get

echo "--- Building Flutter web ---"
flutter build web --release \
  --dart-define=GEMINI_API_KEY="${GEMINI_API_KEY:-}" \
  --dart-define=GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.5-flash}"

echo "--- Build complete ---"
