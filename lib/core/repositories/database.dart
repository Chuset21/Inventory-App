import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/repositories/repository_exception.dart';
import 'package:inventory_app/data/models/models.dart';

final _databaseRepositoryProvider = Provider<DatabasesRepository>((ref) {
  return DatabasesRepository(ref);
});

class DatabasesRepository with RepositoryExceptionMixin {
  DatabasesRepository(this._ref);

  final Ref _ref;
  static const _uniqueDocumentID = 'unique()';

  static Provider<DatabasesRepository> get provider =>
      _databaseRepositoryProvider;

  Realtime get _realtime => _ref.read(Dependency.realtime);

  Databases get _databases => _ref.read(Dependency.databases);

  Future<Iterable<Item>> getItems() {
    return exceptionHandlerFuture(_getItems());
  }

  Future<Iterable<Item>> _getItems() async {
    final documents = (await _databases.listDocuments(
      collectionId: collectionId,
      databaseId: databaseId,
    ))
        .documents;

    return documents.map((doc) => Item.fromJson(doc.data));
  }

  Future<void> updateItem({required String oldItemId, required Item updatedItem}) async {
    return exceptionHandlerFuture(await _databases.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: updatedItem.id!,
      data: updatedItem.copyWith(id: null).toJson(),
    ));
  }

  Future<void> removeItem({required String itemId}) async {
    return exceptionHandlerFuture(
      await _databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: itemId),
    );
  }

  Future<void> addItem({required Item item}) async {
    return exceptionHandlerFuture(await _databases.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: _uniqueDocumentID,
      data: item.copyWith(id: null).toJson(),
    ));
  }

  RealtimeSubscription subscribeToChanges() => _subscribeToChanges();

  RealtimeSubscription _subscribeToChanges() {
    return exceptionHandler(
        _realtime.subscribe(['collections.$collectionId.documents']));
  }
}
