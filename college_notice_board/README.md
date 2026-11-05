# College Notice Board

**Topic:** College notice board
**Programme:** Flutter Application Development Programme (IITM Pravartak and BodhBridge Flutter Lab)

## Description

An Android app where college staff and students post notices, browse them by department, open a notice for full details, and pin the important ones. Notices are saved on the phone, so they are still there after the app restarts.

## Screens

1. **Notice list** (main screen): loading, error with Retry, empty, and data states. Department filter chips at the top.
2. **Notice detail:** full description, department, date, poster, with pin and delete.
3. **Post notice (form):** title, description, department, date and posted by, all validated.
4. **Pinned notices:** only the notices the user has pinned.

## Screenshots

Add at least three screenshots to a `screenshots/` folder and list them here.

![Notice list](screenshots/list.png)
![Notice detail](screenshots/detail.png)
![Post notice form](screenshots/form.png)

## Data source

No internet API. Notices are created by the user in the form and stored on the device with `shared_preferences` (as JSON). No API key is used.

## Tech

Flutter (stable, 3.35 or newer), Dart with null safety, Provider (`ChangeNotifier`), `shared_preferences`. Android only.

## Project structure

```
lib/
  main.dart, app.dart, app_theme.dart, app_strings.dart
  models/     notice.dart, departments.dart
  services/   notice_storage_service.dart, notice_provider.dart
  screens/    notice_list_screen.dart, notice_detail_screen.dart,
              notice_form_screen.dart, pinned_notices_screen.dart
  widgets/    notice_card.dart, department_filter_bar.dart, message_view.dart
test/         widget_test.dart
```

## How to run

1. Install Flutter (stable, 3.35 or newer), Android Studio with the Flutter and Dart plugins, and JDK 17.
2. Clone the repository and open the folder.
3. If the `android/` folder is missing, run:
   `flutter create --platforms=android --project-name college_notice_board .`
4. Run `flutter pub get`.
5. Start an emulator or connect a phone, then run `flutter run`.
6. Run the tests with `flutter test`.
7. Build the release APK with `flutter build apk --release`. The file is at `build/app/outputs/flutter-apk/app-release.apk`.

## Team

| Member | Parts built |
| --- | --- |
| Pavan Ravella | Everything: model, storage service, Provider store, all four screens, widgets, theme, tests, README, defect log |

## Defect log

See [DEFECT_LOG.md](DEFECT_LOG.md).
