import 'package:flutter/material.dart';
import '../../../data/models/notification_item.dart';
import '../../../services/notification_service.dart';
import '../../../services/api_client.dart';
import '../../../components/notification_card.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({super.key});

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  static const _bg = Color(0xFFF9FAFB);

  late Future<List<NotificationItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = NotificationService.list();
  }

  void _reload() {
    setState(() {
      _future = NotificationService.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const TabHeader(
            title: 'Notifikasi',
            subtitle: 'Update inventori dapurmu',
          ),
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final err = snapshot.error;
                  final msg = err is ApiException
                      ? err.message
                      : 'Tidak dapat terhubung ke server';
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(msg),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _reload,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada notifikasi'));
                }
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    children: _buildNotificationList(items),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationList(List<NotificationItem> items) {
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
