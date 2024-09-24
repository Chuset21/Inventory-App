import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/repositories/repositories.dart';

import 'settings/appwrite_config_provider.dart';

abstract class Dependency {
  static Provider<Client> get client => _clientProvider;

  static Provider<Databases> get databases => _databasesProvider;

  static Provider<Realtime> get realtime => _realtimeProvider;
}

abstract class Repository {
  static Provider<DatabasesRepository> get databases =>
      DatabasesRepository.provider;
}

final _clientProvider = Provider<Client>(
  (ref) {
    final appwriteConfig =
        ref.watch(appwriteConfigProvider); // Watch the AppwriteConfigProvider
    return Client()
        .setProject(appwriteConfig.projectId)
        .setSelfSigned(status: true)
        .setEndpoint(appwriteConfig.endpoint);
  },
);

final _databasesProvider =
    Provider<Databases>((ref) => Databases(ref.watch(_clientProvider)));

final _realtimeProvider =
    Provider<Realtime>((ref) => Realtime(ref.watch(_clientProvider)));
