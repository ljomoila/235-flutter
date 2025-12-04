#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# -----------------------------
# Set version/build from pubspec.yaml
# -----------------------------
PUBSPEC_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}') 
# Example: 1.0.4+45

# Split version and build
IFS='+' read -r FLUTTER_VERSION FLUTTER_BUILD <<< "$PUBSPEC_VERSION"

echo "Setting version $FLUTTER_VERSION and build $FLUTTER_BUILD in pubspec.yaml"

# Replace in pubspec.yaml
sed -i '' -E "s/(version: .*\\+)[0-9]+/\1$FLUTTER_BUILD/" pubspec.yaml

# Show updated version
grep "^version: " pubspec.yaml

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

cd ..

echo "Running Flutter build with API_BASE_URL=$API_BASE_URL"

flutter build ipa \
  --release \
  --no-codesign \
  --dart-define=API_BASE_URL=$API_BASE_URL \
  --dart-define=API_KEY_VALUE=$API_KEY_VALUE \

exit 0