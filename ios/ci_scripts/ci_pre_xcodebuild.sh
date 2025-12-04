#!/bin/sh
set -e

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
#export PATH="$PATH:$(pwd)/flutter/bin"

flutter pub get

echo "Running Flutter tests..."
flutter test --no-pub

echo "Flutter tests completed."