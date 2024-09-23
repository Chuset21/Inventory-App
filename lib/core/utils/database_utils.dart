import 'package:appwrite/models.dart';
import 'package:inventory_app/data/models/models.dart';

abstract class DatabaseUtils {
  static Iterable<Item> mapDocumentsToItems(Iterable<Document> documents) =>
      documents.map((doc) => Item.fromJson(doc.data));
}
