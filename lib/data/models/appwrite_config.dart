import 'package:equatable/equatable.dart';

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
