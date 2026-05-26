// Model untuk struktur data barang
class InventoryItem {
  final String name;
  final String icon;
  final int stock;
  final String unit;
  final String expiredInfo;
  final String category; // 'kulkas', 'freezer', atau 'rak_dapur'

  InventoryItem({
    required this.name,
    required this.icon,
    required this.stock,
    required this.unit,
    required this.expiredInfo,
    required this.category,
  });
}

// Array Data Khusus Inventory
List<InventoryItem> dummyInventoryData = [
  // Data Kulkas
  InventoryItem(
    name: 'Sawi Hijau',
    icon: '🥬',
    stock: 2,
    unit: 'ikat',
    expiredInfo: '3 Hari Lagi',
    category: 'kulkas',
  ),
  InventoryItem(
    name: 'Wortel Segar',
    icon: '🥕',
    stock: 5,
    unit: 'biji',
    expiredInfo: '5 Hari Lagi',
    category: 'kulkas',
  ),
  InventoryItem(
    name: 'Susu Kotak',
    icon: '🥛',
    stock: 1,
    unit: 'liter',
    expiredInfo: '2 Hari Lagi',
    category: 'kulkas',
  ),

  // Data Freezer
  InventoryItem(
    name: 'Daging Sapi',
    icon: '🥩',
    stock: 1,
    unit: 'kg',
    expiredInfo: '30 Hari Lagi',
    category: 'freezer',
  ),
  InventoryItem(
    name: 'Ikan Tuna',
    icon: '🐟',
    stock: 3,
    unit: 'ekor',
    expiredInfo: '14 Hari Lagi',
    category: 'freezer',
  ),
  InventoryItem(
    name: 'Es Krim Vanila',
    icon: '🍨',
    stock: 2,
    unit: 'cup',
    expiredInfo: '60 Hari Lagi',
    category: 'freezer',
  ),

  // Data Rak Dapur
  InventoryItem(
    name: 'Bawang Merah',
    icon: '🧅',
    stock: 10,
    unit: 'siung',
    expiredInfo: '12 Hari Lagi',
    category: 'rak_dapur',
  ),
  InventoryItem(
    name: 'Minyak Goreng',
    icon: '🍾',
    stock: 2,
    unit: 'liter',
    expiredInfo: '6 Bulan Lagi',
    category: 'rak_dapur',
  ),
  InventoryItem(
    name: 'Indomie Goreng',
    icon: '🍜',
    stock: 8,
    unit: 'bungkus',
    expiredInfo: '5 Bulan Lagi',
    category: 'rak_dapur',
  ),
];
