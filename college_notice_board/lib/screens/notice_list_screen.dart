import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_strings.dart';
import '../services/notice_provider.dart';
import '../widgets/department_filter_bar.dart';
import '../widgets/message_view.dart';
import '../widgets/notice_card.dart';
import 'notice_detail_screen.dart';
import 'notice_form_screen.dart';
import 'pinned_notices_screen.dart';

/// Main screen. Shows one of four states: loading, error with retry,
/// empty, or the list of notices.
class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({super.key});

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  bool _navigating = false;

  Future<void> _open(Widget page) async {
    if (_navigating) {
      return;
    }
    _navigating = true;
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => page));
    _navigating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            tooltip: 'Pinned notices',
            icon: const Icon(Icons.push_pin_outlined),
            onPressed: () => _open(const PinnedNoticesScreen()),
          ),
        ],
      ),
      body: Consumer<NoticeProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              if (provider.status == LoadStatus.ready && provider.hasNotices)
                DepartmentFilterBar(
                  selected: provider.selectedDepartment,
                  onSelected: provider.selectDepartment,
                ),
              Expanded(child: _buildContent(context, provider)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(const NoticeFormScreen()),
        icon: const Icon(Icons.add),
        label: const Text('Post notice'),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NoticeProvider provider) {
    switch (provider.status) {
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.error:
        return MessageView(
          icon: Icons.error_outline,
          message: provider.errorMessage ?? 'Something went wrong.',
          actionLabel: 'Retry',
          onAction: provider.load,
        );
      case LoadStatus.ready:
        if (!provider.hasNotices) {
          return const MessageView(
            icon: Icons.campaign_outlined,
            message: 'No notices yet',
          );
        }
        final notices = provider.visibleNotices;
        if (notices.isEmpty) {
          return MessageView(
            icon: Icons.filter_alt_off_outlined,
            message: 'No notices for ${provider.selectedDepartment}',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 88),
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
        );
    }
  }
}
