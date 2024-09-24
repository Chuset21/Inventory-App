import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/repositories/repository_exception.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';

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

  Future<Iterable<Item>> getItems({Function? onErrorCallback}) {
    return exceptionHandler(_getItems(), onErrorCallback: onErrorCallback);
  }

  Future<Iterable<Item>> _getItems() async {
    final documents = (await _databases.listDocuments(
      collectionId: collectionId,
      databaseId: databaseId,
    ))
        .documents;

    return documents.map((doc) => Item.fromJson(doc.data));
  }

  Future<void> updateItem(
      {required String oldItemId,
      required Item updatedItem,
      Function? onErrorCallback}) async {
    return exceptionHandler(
      await _databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: oldItemId,
        data: updatedItem.toJson(),
      ),
      onErrorCallback: onErrorCallback,
    );
  }

  Future<void> removeItem(
      {required String itemId, Function? onErrorCallback}) async {
    return exceptionHandler(
      await _databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: itemId),
      onErrorCallback: onErrorCallback,
    );
  }

  Future<void> addItem({required Item item, Function? onErrorCallback}) async {
    return exceptionHandler(
      await _databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: item.id,
        data: item.toJson(),
      ),
      onErrorCallback: onErrorCallback,
    );
  }

  void listenToItems(
      {required Function(Iterable<Item>) onItemsUpdated,
      Function? onErrorCallback,
      Function? onLostConnectionCallback}) {
    final channels = [
      'databases.$databaseId.collections.$collectionId.documents'
    ];

    cancelSubscription();
    _subscription = _realtime.subscribe(channels).stream.listen((event) {
      getItems().then(onItemsUpdated);
    }, onError: (o, st) {
      logger.severe('Error in realtime stream');
      onErrorCallback?.call();
    }, onDone: () {
      onLostConnectionCallback?.call();
    });
  }

  void cancelSubscription() {
    if (_subscription != null) {
      logger.info('Cancelling subscription');
      _subscription!.cancel();
    }
  }
}
