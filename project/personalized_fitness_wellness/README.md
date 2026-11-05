# FitNest — Personalized Fitness and Wellness App

A Flutter UI lab project with personalized workout plans, manual daily activity tracking, progress indicators and editable goals.

## Run in Chrome

Open this project folder in VS Code or Android Studio. In its terminal, run:

```sh
flutter pub get
flutter run -d chrome --web-port 7357
```

From a terminal elsewhere on your Mac:

```sh
cd "/Users/timothysaxena/Downloads/MGIT/Sem-V/9. Flutter/personalized_fitness_wellness"
flutter pub get
flutter run -d chrome --web-port 7357
```

Use the same browser and port for subsequent launches so the browser uses the same local storage. A first launch includes seven days of clearly labelled sample history. Internet access is needed for initial dependency installation and may be needed for Flutter's web renderer assets.

## Android or another device

Start the Android emulator or connect a configured phone, then run:

```sh
flutter devices
flutter run -d DEVICE_ID
```

Replace DEVICE_ID with the device identifier shown by Flutter. Android/iOS/macOS scaffolds are supplied, but only the web build has been verified in this environment. Native targets require their usual SDKs, signing or desktop build tools.

## Screenshots for the report

The Word report is in the parent coursework folder as `Flutter_UI_Lab_Personalized_Fitness_and_Wellness_App.docx`. It uses the supplied reference's student details, guide and report structure. Add your own screenshots to its output pages.

1. **Overview:** capture the greeting, daily metrics and suggested workout. Scroll if using a phone-sized window.
2. **Workout plans:** open Workouts and capture the recommended plan and filters. Tap a plan to show the exercise checklist.
3. **Activity journal:** open Activity → Log activity. Enter `Evening walk`, `30` minutes and `2500` steps. Save and capture the timeline.
4. **Progress:** capture the seven-day chart and summary cards.
5. **Goals:** edit a target, save it and capture the updated progress indicators.
6. **Workout completion:** open a plan, check every exercise, then tap Finish workout. Capture the confirmation.

Optional screenshots: blank activity-form validation; personalized profile; desktop NavigationRail and mobile bottom navigation.

## Functional features

- Five main tabs: Overview, Workouts, Activity, Progress and Goals.
- Name, focus and experience customization. Focus and level determine the suggested workout.
- Workout category filters, exercise checklists and completion logging. A plan can be completed once per day; deleting its activity entry allows it to be logged again.
- Manual walking, running, cycling, workout, mindfulness, water and sleep entries. Dates can be selected from the previous 365 days through today.
- Daily steps, active minutes, hydration and sleep; rolling seven-day workout totals and animated progress bars.
- Editable daily step, movement and hydration targets plus a seven-day workout target.
- Local JSON storage using SharedPreferencesAsync. Storage failures display a retry message.
- Profile → Start fresh clears all activity entries after confirmation. Profile → Restore demo history replaces entries with sample data after confirmation. Both preserve profile choices and goals.
- Wellness notes load from a local asynchronous repository. There is no live REST backend, login, sensor, wearable connection or automatic step counting.

## Project structure

- `lib/main.dart`: startup, saved-data loading, theme, routes and adaptive navigation.
- `lib/data/fitness_store.dart`: activity/workout models, shared state, date totals, serialization and local wellness repository.
- `lib/ui/components.dart`: reusable cards, labels, metric indicators and formatting helpers.
- `lib/ui/screens.dart`: dashboard, workouts, journal, charts, goals and forms.
- `test/fitness_store_test.dart`: persistence, dates, deletion and storage error handling.
- `test/widget_test.dart`: responsive layouts, forms, workout completion, goal editing and personalization.

## Verification

```sh
flutter analyze
flutter test
flutter build web
```

Verified with Flutter 3.47.3 and Dart 3.13.3: analysis has no issues, all 11 tests pass, and the release web build succeeds. Layout tests cover 320, 390 and 1200 pixel widths.

## References

- [Flutter form validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Flutter testing](https://docs.flutter.dev/testing/overview)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
