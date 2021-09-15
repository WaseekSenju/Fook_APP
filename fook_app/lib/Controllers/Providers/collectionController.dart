import 'package:flutter/cupertino.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Models/collections.dart';

class CollectionController extends ChangeNotifier {
  Collections collectionsList = Collections(data: []);
  Collections userCollectionsList = Collections(data: []);
  final List<String> collectionNames = [];

  bool loading = false;

  Future<void> getAllCollections() async {
    loading = true;
    collectionsList = await BackendServices.getCollections();

    loading = false;
    notifyListeners();
  }

  Future<void> getUserCollections() async {
    loading = true;
    userCollectionsList = await BackendServices.getCurrentUserCollections();
    userCollectionsList.data.forEach((element) {
      collectionNames.add(element.name);
    });
    loading = false;
    notifyListeners();
  }
}
