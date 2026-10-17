#!/bin/bash
# Installs Flutter for Claude Code cloud sessions so the Dart MCP server,
# flutter analyze, flutter test and flutter build web work.
# Runs only in the cloud ($CLAUDE_CODE_REMOTE=true) and skips the download
# when the right Flutter version is already installed.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_VERSION="3.47.7"
# sha256 of flutter_linux_3.47.7-stable.tar.xz from
# https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
FLUTTER_SHA256="af7455f540df951184c7953fbe3cf884766e7541dacf8571f9f582db03dd6230"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_HOME="/opt/flutter"

installed_version() {
  # The SDK records its version in this file; reading it avoids starting Flutter.
  sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p' \
    "$FLUTTER_HOME/bin/cache/flutter.version.json" 2>/dev/null || true
}

if [ "$(installed_version)" != "$FLUTTER_VERSION" ]; then
  echo "Installing Flutter $FLUTTER_VERSION..." >&2
  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT
  curl -fsSL --retry 3 -o "$tmp_dir/flutter.tar.xz" "$FLUTTER_URL"
  echo "$FLUTTER_SHA256  $tmp_dir/flutter.tar.xz" | sha256sum -c --quiet -
  rm -rf "$FLUTTER_HOME"
  tar -xJf "$tmp_dir/flutter.tar.xz" --no-same-owner -C "$(dirname "$FLUTTER_HOME")"
fi

# The SDK is a git checkout owned by a different user than the one running it.
if ! git config --global --get-all safe.directory | grep -qx "$FLUTTER_HOME"; then
  git config --global --add safe.directory "$FLUTTER_HOME"
fi

# Put flutter and dart on PATH for every process, including MCP servers
# started by Claude Code, and for this session's shell commands.
ln -sf "$FLUTTER_HOME/bin/flutter" /usr/local/bin/flutter
ln -sf "$FLUTTER_HOME/bin/dart" /usr/local/bin/dart
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$FLUTTER_HOME/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

# Flutter web (flutter run -d chrome, web tests) uses the cloud's preinstalled
# Chromium, since Google Chrome isn't installed there.
CHROMIUM="/opt/pw-browsers/chromium"
if [ -x "$CHROMIUM" ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export CHROME_EXECUTABLE=\"$CHROMIUM\"" >> "$CLAUDE_ENV_FILE"
fi

# Cloud containers are throwaway, so don't send usage statistics to Google.
flutter --disable-analytics >/dev/null 2>&1 || true
dart --disable-analytics >/dev/null 2>&1 || true

flutter --version
flutter precache --web >/dev/null

cd "$CLAUDE_PROJECT_DIR"
flutter pub get
