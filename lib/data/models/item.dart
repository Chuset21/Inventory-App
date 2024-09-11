final class Item {
  final String name;
  final String category;
  final String location;

  Item({
    required this.name,
    required this.category,
    required this.location,
  });

  /// Creates a copy of this item but with the given fields replaced with the new values.
  Item copyWith({
    String? name,
    String? category,
    String? location,
  }) {
    return Item(
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
    );
  }

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
