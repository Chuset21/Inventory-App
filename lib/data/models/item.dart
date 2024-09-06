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
        other.name.toLowerCase() == name.toLowerCase() &&
        other.category.toLowerCase() == category.toLowerCase() &&
        other.location.toLowerCase() == location.toLowerCase();
  }

  @override
  int get hashCode =>
      name.toLowerCase().hashCode ^
      category.toLowerCase().hashCode ^
      location.toLowerCase().hashCode;
}
