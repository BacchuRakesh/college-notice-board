import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_strings.dart';
import 'app_theme.dart';
import 'screens/notice_list_screen.dart';
import 'services/notice_provider.dart';
import 'services/notice_storage_service.dart';

class NoticeBoardApp extends StatelessWidget {
  const NoticeBoardApp({super.key, this.storage});

  /// Lets tests supply their own storage. The real app leaves this null.
  final NoticeStorageService? storage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoticeProvider>(
      create: (_) => NoticeProvider(storage ?? NoticeStorageService())..load(),
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const NoticeListScreen(),
      ),
    );
  }
}
