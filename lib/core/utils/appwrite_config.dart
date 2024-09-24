import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/data/models/models.dart';

/// This function must be called after the .env file has been read.
AppwriteConfig getDefaultAppwriteConfig() => AppwriteConfig(
      endpoint: dotenv.env['APPWRITE_ENDPOINT']!,
      projectId: dotenv.env['APPWRITE_PROJECT_ID']!,
      databaseId: dotenv.env['DATABASE_ID']!,
      collectionId: dotenv.env['COLLECTION_ID']!,
    );
