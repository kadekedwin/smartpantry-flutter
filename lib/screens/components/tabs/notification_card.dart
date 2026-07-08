import 'package:flutter/material.dart';
import '../../../models/notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor;
    Color lightColor;
    IconData iconData;

    switch (item.type) {
      case NotificationType.cooking:
        primaryColor = const Color(0xFF059669); // Green
        lightColor = const Color(0xFFD1FAE5);
        iconData = Icons.restaurant;
        break;
      case NotificationType.stock:
        primaryColor = const Color(0xFFF97316); // Orange
        lightColor = const Color(0xFFFFEDD5);
        iconData = Icons.shopping_cart_outlined;
        break;
      case NotificationType.warning:
        primaryColor = const Color(0xFFDC2626); // Red
        lightColor = const Color(0xFFFEE2E2);
        iconData = Icons.warning_amber_rounded;
        break;
      case NotificationType.expired:
        primaryColor = const Color(0xFF9CA3AF); // Grey
        lightColor = const Color(0xFFF3F4F6);
        iconData = Icons.block;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: primaryColor,
                width: 6,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
