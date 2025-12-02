#!/bin/bash

# Navigate to repo root
cd "$XCS_SOURCE_DIR"

# Fetch Flutter dependencies
flutter pub get

# Move to iOS folder and install Pods
cd ios
pod install --repo-update