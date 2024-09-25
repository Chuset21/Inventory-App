import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/data/models/models.dart';

/// This function must be called after the .env file has been read.
AppwriteConfig getDefaultAppwriteConfig() => AppwriteConfig(
      endpoint: dotenv.env[endpointEnvKey] ?? '',
      projectId: dotenv.env[projectIdEnvKey] ?? '',
      databaseId: dotenv.env[databaseIdEnvKey] ?? '',
      collectionId: dotenv.env[collectionIdEnvKey] ?? '',
    );

Future<bool> isConfigValid(AppwriteConfig appwriteConfig) async {
  try {
    final client = Client()
        .setProject(appwriteConfig.projectId)
        .setSelfSigned(status: true)
        .setEndpoint(appwriteConfig.endpoint);

    final databases = Databases(client);

    await databases.listDocuments(
      collectionId: appwriteConfig.collectionId,
      databaseId: appwriteConfig.databaseId,
    );
    return true;
  } catch (_) {
    return false;
  }
}
