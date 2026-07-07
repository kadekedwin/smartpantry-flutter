import 'package:flutter/material.dart';
import '../../../data/models/notification_item.dart';
import '../notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItem> items;
  final Future<void> Function() onRefresh;

  const NotificationList({
    super.key,
    required this.items,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: _buildList(),
      ),
    );
  }

  List<Widget> _buildList() {
    final List<Widget> widgets = [];
    String currentGroup = '';

    for (final item in items) {
      if (item.group != currentGroup) {
        currentGroup = item.group;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: widgets.isEmpty ? 0 : 16),
            child: Text(
              currentGroup,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }
      widgets.add(NotificationCard(item: item));
    }

    return widgets;
  }
}
