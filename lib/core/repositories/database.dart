import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';

import 'repository_exception.dart';

// TODO: not sure if we should watch appwriteConfigProvider here
final _databaseRepositoryProvider = Provider<DatabasesRepository>((ref) {
  return DatabasesRepository(ref);
});

class DatabasesRepository with RepositoryExceptionMixin {
  DatabasesRepository(this._ref);

  final Ref _ref;
  StreamSubscription? _subscription;

  static Provider<DatabasesRepository> get provider =>
      _databaseRepositoryProvider;

  Realtime get _realtime => _ref.read(Dependency.realtime);

  Databases get _databases => _ref.read(Dependency.databases);

  AppwriteConfig get _appwriteConfig => _ref.read(appwriteConfigProvider);

  List<String> get _channels {
    return [
      'databases.${_appwriteConfig.databaseId}.collections.${_appwriteConfig.collectionId}.documents'
    ];
  }

  Future<Iterable<Item>> getItems({Function? onErrorCallback}) {
    return exceptionHandler(_getItems(), onErrorCallback: onErrorCallback);
  }

  Future<Iterable<Item>> _getItems() async {
    final documents = (await _databases.listDocuments(
      collectionId: _appwriteConfig.collectionId,
      databaseId: _appwriteConfig.databaseId,
    ))
        .documents;

    return documents.map((doc) => Item.fromJson(doc.data));
  }

  Future<void> updateItem(
      {required String oldItemId,
      required Item updatedItem,
      Function? onErrorCallback}) async {
    return exceptionHandler(
      _databases.updateDocument(
        databaseId: _appwriteConfig.databaseId,
        collectionId: _appwriteConfig.collectionId,
        documentId: oldItemId,
        data: updatedItem.toJson(),
      ),
      onErrorCallback: onErrorCallback,
    );
  }

  Future<void> removeItem(
      {required String itemId, Function? onErrorCallback}) async {
    return exceptionHandler(
      _databases.deleteDocument(
          databaseId: _appwriteConfig.databaseId,
          collectionId: _appwriteConfig.collectionId,
          documentId: itemId),
      onErrorCallback: onErrorCallback,
    );
  }

  Future<void> addItem({required Item item, Function? onErrorCallback}) async {
    return exceptionHandler(
      _databases.createDocument(
        databaseId: _appwriteConfig.databaseId,
        collectionId: _appwriteConfig.collectionId,
        documentId: item.id,
        data: item.toJson(),
      ),
      onErrorCallback: onErrorCallback,
    );
  }

  void listenToItems({
    required Function(Iterable<Item>) onItemsUpdated,
    Function? onErrorCallback,
    Function? onLostConnectionCallback,
  }) {
    return instantExceptionHandler(
      () => _listenToItems(
          onItemsUpdated: onItemsUpdated,
          onErrorCallback: onErrorCallback,
          onLostConnectionCallback: onLostConnectionCallback),
    );
  }

  void _listenToItems({
    required Function(Iterable<Item>) onItemsUpdated,
    Function? onErrorCallback,
    Function? onLostConnectionCallback,
  }) {
    cancelSubscription();
    _subscription = _realtime.subscribe(_channels).stream.listen((event) {
      getItems().then(onItemsUpdated);
    }, onError: (o, st) {
      logger.severe('Error in realtime stream');
      onErrorCallback?.call();
    }, onDone: () {
      onLostConnectionCallback?.call();
    });
  }

  void cancelSubscription() {
    return instantExceptionHandler(_cancelSubscription);
  }

  void _cancelSubscription() {
    if (_subscription != null) {
      logger.info('Cancelling subscription');
      _subscription!.cancel();
    }
  }
}
