#!/bin/bash
set -e

cd "$XCS_SOURCE_DIR"

# 1. Download Flutter SDK
if [ ! -d "$XCS_SOURCE_DIR/flutter_sdk" ]; then
  git clone -b stable https://github.com/flutter/flutter.git flutter_sdk
fi
export PATH="$XCS_SOURCE_DIR/flutter_sdk/bin:$PATH"

# 2. Fetch Flutter dependencies
flutter pub get

# 3. iOS Pods
cd ios
pod install --repo-update