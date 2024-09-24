import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/appwrite.dart';
import 'package:inventory_app/core/repositories/repositories.dart';

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
  (ref) => Client()
      .setProject(appwriteProjectId)
      .setSelfSigned(status: true)
      .setEndpoint(appwriteEndpoint),
);

final _databasesProvider =
    Provider<Databases>((ref) => Databases(ref.read(_clientProvider)));

final _realtimeProvider =
    Provider<Realtime>((ref) => Realtime(ref.read(_clientProvider)));
