class ShoppingItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final bool isBought;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isBought = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'].toString(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isBought: json['is_bought'] as bool? ?? false,
    );
  }
}
