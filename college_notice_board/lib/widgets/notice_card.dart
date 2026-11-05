import 'package:flutter/material.dart';

import '../models/notice.dart';

/// One row in a notice list. Ignores extra taps while the detail screen is
/// still opening, so fast repeated taps cannot open it twice.
class NoticeCard extends StatefulWidget {
  const NoticeCard({super.key, required this.notice, required this.onOpen});

  final Notice notice;
  final Future<void> Function() onOpen;

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  bool _opening = false;

  Future<void> _handleTap() async {
    if (_opening) {
      return;
    }
    _opening = true;
    await widget.onOpen();
    _opening = false;
  }

  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notice.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (notice.pinned)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.push_pin,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${notice.department} • ${notice.formattedDate}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notice.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
