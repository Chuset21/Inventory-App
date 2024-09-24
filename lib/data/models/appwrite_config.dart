import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'appwrite_config.g.dart';

@CopyWith()
class AppwriteConfig extends Equatable {
  final String endpoint;
  final String projectId;
  final String databaseId;
  final String collectionId;

  const AppwriteConfig({
    required this.endpoint,
    required this.projectId,
    required this.databaseId,
    required this.collectionId,
  });

  @override
  List<Object?> get props => [endpoint, projectId, databaseId, collectionId];
}
