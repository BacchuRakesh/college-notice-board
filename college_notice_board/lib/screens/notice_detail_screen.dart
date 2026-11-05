import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notice_provider.dart';
import '../widgets/message_view.dart';

/// Full view of one notice, with pin and delete actions.
class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({super.key, required this.noticeId});

  final String noticeId;

  Future<void> _togglePin(BuildContext context) async {
    final ok = await context.read<NoticeProvider>().togglePin(noticeId);
    if (!ok && context.mounted) {
      _showMessage(context, 'Could not update the notice. Try again.');
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete notice?'),
        content: const Text('This notice will be removed from this phone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final navigator = Navigator.of(context);
    final ok = await context.read<NoticeProvider>().deleteNotice(noticeId);
    if (!context.mounted) {
      return;
    }
    if (ok) {
      navigator.pop();
    } else {
      _showMessage(context, 'Could not delete the notice. Try again.');
    }
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final notice = context.watch<NoticeProvider>().findById(noticeId);
    if (notice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notice')),
        body: const MessageView(
          icon: Icons.search_off,
          message: 'This notice no longer exists.',
        ),
      );
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
        actions: [
          IconButton(
            tooltip: notice.pinned ? 'Unpin notice' : 'Pin notice',
            icon: Icon(
              notice.pinned ? Icons.push_pin : Icons.push_pin_outlined,
            ),
            onPressed: () => _togglePin(context),
          ),
          IconButton(
            tooltip: 'Delete notice',
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(notice.department)),
            const SizedBox(height: 12),
            Text(notice.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text('Posted by ${notice.postedBy}')),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(notice.formattedDate)),
              ],
            ),
            const Divider(height: 32),
            Text(notice.description, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
