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
  final String time;
  final NotificationType type;
  final String group;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    this.time = '',
    required this.type,
    required this.group,
  });
}

final List<NotificationItem> dummyNotifications = [
  const NotificationItem(
    id: '1',
    title: 'Waktunya Masak!',
    description: 'Rekomendasi menu hari ini sudah siap untukmu',
    time: '2 jam yang lalu',
    type: NotificationType.cooking,
    group: 'HARI INI',
  ),
  const NotificationItem(
    id: '2',
    title: 'Stok Telur Menipis',
    description: 'Jangan lupa masukan tempe ke daftar belanja',
    type: NotificationType.stock,
    group: 'KEMARIN',
  ),
  const NotificationItem(
    id: '3',
    title: 'Stok Telur Menipis',
    description: 'Jangan lupa masukan tempe ke daftar belanja',
    type: NotificationType.stock,
    group: 'KEMARIN',
  ),
  const NotificationItem(
    id: '4',
    title: 'Perhatian: Bayam',
    description: 'Sayur bayam hampir rusak, segera masak sekarang',
    type: NotificationType.warning,
    group: '7 HARI LALU',
  ),
  const NotificationItem(
    id: '5',
    title: 'Bayam Kedaluarsa',
    description: 'Barang sudah rusak dan dihapus dari inventaris',
    type: NotificationType.expired,
    group: '7 HARI LALU',
  ),
  const NotificationItem(
    id: '6',
    title: 'Bayam Kedaluarsa',
    description: 'Barang sudah rusak dan dihapus dari inventaris',
    type: NotificationType.expired,
    group: '30 HARI LALU',
  ),
];
