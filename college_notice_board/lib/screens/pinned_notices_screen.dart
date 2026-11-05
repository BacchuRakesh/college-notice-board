import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notice_provider.dart';
import '../widgets/message_view.dart';
import '../widgets/notice_card.dart';
import 'notice_detail_screen.dart';

/// Shows only the notices the user has pinned.
class PinnedNoticesScreen extends StatelessWidget {
  const PinnedNoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = context.watch<NoticeProvider>().pinnedNotices;
    return Scaffold(
      appBar: AppBar(title: const Text('Pinned notices')),
      body: notices.isEmpty
          ? const MessageView(
              icon: Icons.push_pin_outlined,
              message: 'No pinned notices. Open a notice and tap the pin.',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return NoticeCard(
                  key: ValueKey(notice.id),
                  notice: notice,
                  onOpen: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => NoticeDetailScreen(noticeId: notice.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
