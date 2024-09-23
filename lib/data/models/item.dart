class _ItemFieldNames {
  static const String id = '\$id';
  static const String name = 'name';
  static const String category = 'category';
  static const String location = 'location';
  static const String quantity = 'quantity';
}

class Item {
  final String id;
  final String name;
  final String category;
  final String location;
  final int quantity;

  const Item({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        _ItemFieldNames.id: id,
        _ItemFieldNames.name: name,
        _ItemFieldNames.category: category,
        _ItemFieldNames.location: location,
        _ItemFieldNames.quantity: quantity,
      };

  factory Item.fromJson(Map<String, dynamic> doc) => Item(
        id: doc[_ItemFieldNames.id],
        name: doc[_ItemFieldNames.name],
        category: doc[_ItemFieldNames.category],
        location: doc[_ItemFieldNames.location],
        quantity: doc[_ItemFieldNames.quantity],
      );
}
