import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'item.g.dart';

@CopyWith()
final class Item extends Equatable {
  final String name;
  final String category;
  final String location;

  const Item({
    required this.name,
    required this.category,
    required this.location,
  });

  @override
  List<Object?> get props => [name, category, location];
}
