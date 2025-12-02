#!/bin/bash
# ===============================================
# ci_pre_xcodebuild.sh
# Flutter + iOS pre-build script for Xcode Cloud
# ===============================================

# Exit immediately if a command fails
set -e

log() {
  echo "[ci_pre_xcodebuild] $1"
}

run_cmd() {
  local cmd="$1"
  log "Running: $cmd"
  eval "$cmd"
  local status=$?
  if [ $status -ne 0 ]; then
    log "❌ Command failed with exit code $status: $cmd"
    exit $status
  fi
}

log "Starting pre-build script"

# 1️⃣ Go to repo root
if [ -z "$XCS_SOURCE_DIR" ]; then
  log "❌ XCS_SOURCE_DIR is not set"
  exit 1
fi
cd "$XCS_SOURCE_DIR" || exit 1
log "Current directory: $(pwd)"

# 2️⃣ Log environment for debugging
log "PATH: $PATH"
flutter_path=$(which flutter || true)
pod_path=$(which pod || true)
log "flutter: ${flutter_path:-not found}"
log "pod: ${pod_path:-not found}"

# 3️⃣ Install Flutter SDK if not present
if [ -z "$flutter_path" ]; then
  log "Flutter not found, installing Flutter SDK..."
  if [ ! -d "$XCS_SOURCE_DIR/flutter_sdk" ]; then
    run_cmd "git clone -b stable https://github.com/flutter/flutter.git flutter_sdk"
  fi
  export PATH="$XCS_SOURCE_DIR/flutter_sdk/bin:$PATH"
  flutter_path=$(which flutter || true)
  if [ -z "$flutter_path" ]; then
    log "❌ Failed to find Flutter even after install"
    exit 1
  fi
  log "Flutter installed at $flutter_path"
fi

# 4️⃣ Fetch Flutter dependencies
run_cmd "flutter pub get"

# 5️⃣ Navigate to iOS folder
cd ios || exit 1
log "Current iOS directory: $(pwd)"

# 6️⃣ Install Pods
run_cmd "pod install --repo-update"

log "✅ Pre-build script completed successfully"
