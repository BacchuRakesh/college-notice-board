import 'package:college_notice_board/app.dart';
import 'package:college_notice_board/models/notice.dart';
import 'package:college_notice_board/services/notice_provider.dart';
import 'package:college_notice_board/services/notice_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FailingStorage extends NoticeStorageService {
  @override
  Future<List<Notice>> load() async {
    throw Exception('saved data is corrupted');
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the empty message when there are no notices', (
    tester,
  ) async {
    await tester.pumpWidget(const NoticeBoardApp());
    await tester.pumpAndSettle();

    expect(find.text('No notices yet'), findsOneWidget);
  });

  testWidgets('shows an error message with Retry when loading fails', (
    tester,
  ) async {
    await tester.pumpWidget(NoticeBoardApp(storage: FailingStorage()));
    await tester.pumpAndSettle();

    expect(find.text('Could not read the saved notices.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('form shows a message for every invalid field', (tester) async {
    await tester.pumpWidget(const NoticeBoardApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveNoticeButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Enter a description'), findsOneWidget);
    expect(find.text('Select a department'), findsOneWidget);
    expect(find.text('Choose a date'), findsOneWidget);
    expect(find.text('Enter who is posting'), findsOneWidget);
  });

  test('provider saves a notice and loads it again', () async {
    final storage = NoticeStorageService();
    final provider = NoticeProvider(storage);
    await provider.load();

    final ok = await provider.addNotice(
      title: 'Exam timetable',
      description: 'The semester exam timetable is out.',
      department: 'Examination Cell',
      date: DateTime(2026, 11, 20),
      postedBy: 'Exam Cell',
    );
    expect(ok, isTrue);

    final reloaded = NoticeProvider(storage);
    await reloaded.load();
    expect(reloaded.visibleNotices.length, 1);
    expect(reloaded.visibleNotices.first.title, 'Exam timetable');
  });
}
