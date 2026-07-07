import 'package:flutter/material.dart';
import '../../data/models/notification_item.dart';
import '../../services/api_client.dart';
import '../../services/notification_service.dart';
import '../components/tab_header.dart';
import '../components/tabs/notification_list.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({super.key});

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
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
      backgroundColor: const Color(0xFFF9FAFB),
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
                return NotificationList(
                  items: items,
                  onRefresh: () async => _reload(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
