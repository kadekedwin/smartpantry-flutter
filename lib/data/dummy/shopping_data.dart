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
}

final List<ShoppingItem> dummyShoppingList = [
  const ShoppingItem(
    id: '1',
    name: 'Ayam Fillet',
    quantity: 1,
    unit: 'kg',
  ),
];
