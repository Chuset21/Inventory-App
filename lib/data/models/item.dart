final class Item {
  final String name;
  final String type;
  final String location;

  Item({
    required this.name,
    required this.type,
    required this.location,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Item &&
        other.name == name &&
        other.type == type &&
        other.location == location;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ location.hashCode;
}
