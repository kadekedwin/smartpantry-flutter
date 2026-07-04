enum NotificationType {
  cooking,
  stock,
  warning,
  expired,
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      type: _parseType(json['type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static NotificationType _parseType(String value) {
    switch (value) {
      case 'cooking':
        return NotificationType.cooking;
      case 'stock':
        return NotificationType.stock;
      case 'warning':
        return NotificationType.warning;
      case 'expired':
        return NotificationType.expired;
      default:
        return NotificationType.stock;
    }
  }

  String get group {
    final now = DateTime.now();
    final n = DateTime(now.year, now.month, now.day);
    final c = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final days = n.difference(c).inDays;
    if (days <= 0) return 'HARI INI';
    if (days == 1) return 'KEMARIN';
    if (days <= 7) return '7 HARI LALU';
    if (days <= 30) return '30 HARI LALU';
    return 'LEBIH LAMA';
  }

  String get time {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    return '${diff.inDays} hari yang lalu';
  }
}
