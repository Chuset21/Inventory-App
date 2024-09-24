import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  // Private constructor to prevent instantiation
  AppwriteConfig._();

  static final String endpoint = dotenv.env['APPWRITE_ENDPOINT']!;
  static final String projectId = dotenv.env['APPWRITE_PROJECT_ID']!;
  static final String databaseId = dotenv.env['DATABASE_ID']!;
  static final String collectionId = dotenv.env['COLLECTION_ID']!;
}
