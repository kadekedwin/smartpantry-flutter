import 'package:flutter/material.dart';
import '../../../data/dummy/notification_data.dart';
import 'widgets/notification_card.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: _buildNotificationList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 32,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF059669),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifikasi',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Update inventoris dapurmu',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFD1FAE5),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationList() {
    final List<Widget> widgets = [];
    String currentGroup = '';

    for (final item in dummyNotifications) {
      if (item.group != currentGroup) {
        currentGroup = item.group;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12, top: widgets.isEmpty ? 0 : 16),
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

    // Add extra padding at the bottom for better scroll experience
    widgets.add(const SizedBox(height: 24));

    return widgets;
  }
}
