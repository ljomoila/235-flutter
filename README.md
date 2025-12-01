# 235 Flutter

Flutter app that shows NHL scores with a Teletext-inspired UI and highlights players from your selected country. Supports iOS, Android, and Web.

## Features

- Pick a favorite country (persisted with `shared_preferences`) and highlight matching players
- Scroll daily boxscores, jump dates, and pull-to-refresh

## Getting Started

1. Install Flutter (tested with 3.38.3) and platform SDKs for your targets.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. (Optional) Set API endpoint and key. Defaults mirror the RN app. Either export env vars or create `.env.json` (see Run).

## Run

- Use a local `.env.json` (copy `.env.json.example`) and pass it:

  ```json
  {
    "API_BASE_URL": "http://localhost:5069",
    "API_KEY_VALUE": "changeme"
  }
  ```

  - iOS: `flutter run -d ios --dart-define-from-file=.env.json`
  - Android: `flutter run -d android --dart-define-from-file=.env.json`
  - Web: `flutter run -d chrome --web-renderer html --dart-define-from-file=.env.json`

## Tests

```bash
flutter test
```
