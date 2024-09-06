final class Item {
  final String name;
  final String category;
  final String location;

  Item({
    required this.name,
    required this.category,
    required this.location,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Item &&
        other.name == name &&
        other.category == category &&
        other.location == location;
  }

  @override
  int get hashCode => name.hashCode ^ category.hashCode ^ location.hashCode;
}
