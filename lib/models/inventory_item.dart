class InventoryItem {
  final String id;
  final String name;
  final String image;
  final int stock;
  final String unit;
  final DateTime expiredAt;
  final String category;

  InventoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.stock,
    required this.unit,
    required this.expiredAt,
    required this.category,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'].toString(),
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String,
      expiredAt: DateTime.parse(json['expired_at'] as String),
      category: json['category'] as String,
    );
  }

  String get expiredInfo {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final e = DateTime(expiredAt.year, expiredAt.month, expiredAt.day);
    final days = e.difference(t).inDays;
    if (days < 0) return 'Kedaluwarsa';
    if (days == 0) return 'Hari Ini';
    if (days < 30) return '$days Hari Lagi';
    final months = (days / 30).floor();
    return '$months Bulan Lagi';
  }
}
