#!/usr/bin/env bash
# Starts the PawSetu demo against the Firebase emulators:
#   1. builds the Cloud Functions,
#   2. starts the emulators (Auth, Firestore, Storage, Functions, UI),
#   3. loads the demo data,
#   4. opens the app in Chrome with BACKEND=emulator.
# Stop with Ctrl+C (the emulators stop too).
set -euo pipefail
cd "$(dirname "$0")/.."

npm --prefix functions install --silent
npm --prefix functions run build --silent

firebase emulators:start --project demo-pawsetu &
EMULATORS=$!
trap 'kill $EMULATORS 2>/dev/null || true' EXIT

echo "Waiting for the emulators..."
until curl -s http://127.0.0.1:4000 >/dev/null; do sleep 2; done

npm --prefix functions run seed
flutter run -d chrome --dart-define=BACKEND=emulator
