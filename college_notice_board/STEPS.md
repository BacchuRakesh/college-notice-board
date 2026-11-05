# Steps to finish the project

## 1. Set up (about 30 minutes)

1. Install Flutter stable (3.35 or newer), Android Studio with the Flutter and Dart plugins, and JDK 17. Run `flutter doctor` and fix anything marked with a cross.
2. Unzip this folder and open it in Android Studio.
3. In the folder, run this to add the Android files (it does not touch `lib/`, `test/` or `pubspec.yaml`):
   `flutter create --platforms=android --project-name college_notice_board .`
4. Run `flutter pub get`.
5. Start an emulator and run `flutter run`. Confirm you see the empty "No notices yet" screen.
6. Run `flutter analyze` and `flutter test`. Both should pass. If anything fails, fix it before going on.

## 2. Start Git from day one

1. Create a **public** repository on GitHub.
2. In the folder: `git init`, `git add .`, `git commit -m "Initial Flutter project"`, then add the remote and push.
3. From now on commit small and often (one commit per change, on different days).

## 3. Make it yours (requirements GP 7 and "originality")

You must be able to explain every line, so read each file once, then change things:

1. Change the department list in `lib/models/departments.dart` to your college's departments.
2. Change the seed colour in `lib/app_theme.dart`.
3. Rename or restyle things so your app looks clearly your own.

Commit after each change.

## 4. App name and icon (GP 7)

1. App name: open `android/app/src/main/AndroidManifest.xml` and set `android:label="College Notice Board"`.
2. Icon: `assets/icon/app_icon.png` is a starter. Replace it with your own if you like, then run
   `dart run flutter_launcher_icons`.

## 5. Test on a real phone (GP 8, GP 10)

1. Enable Developer options and USB debugging on the phone, connect it, and run `flutter run`.
2. Work through the checklist in `DEFECT_LOG.md`. Log every bug you find, then fix it and mark it Fixed.

## 6. Build the release APK (GP 10)

1. `flutter build apk --release`
2. Copy `build/app/outputs/flutter-apk/app-release.apk` to the phone and install it.
3. Open it and check that posting, pinning, deleting and the restart test all work.

## 7. Finish the submission

1. Take at least 3 screenshots (list, detail, form) and put them in `screenshots/`.
2. Check `README.md` is complete (name, topic, description, screenshots, data source, run steps, your name and parts).
3. Check the repo has no unused files or commented-out code, and that a fresh `git clone` then `flutter pub get` then `flutter run` works.
4. Submit: the GitHub link, the APK file, the README and the defect log.

## 8. Prepare the 5-minute demo

| Time | What to do |
| --- | --- |
| 0:00 to 0:30 | Say who the app is for (students and staff) and what problem it solves (one place for notices). |
| 0:30 to 3:30 | On the phone: post a notice, show a rejected form entry (leave fields empty), filter by department, open a notice, pin it, open Pinned, delete everything to show the empty state. |
| 3:30 to 4:30 | Explain one real problem you hit and how you solved it (for example: stopping double-opening from fast taps, or saving before updating the screen). |
| 4:30 to 5:00 | Show the GitHub commit history and the APK file. |

Practise it twice with a timer. Slides are not accepted, so use the phone.
