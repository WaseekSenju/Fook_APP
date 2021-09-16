import 'package:flutter/cupertino.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Models/collections.dart';

class CollectionController extends ChangeNotifier {
  Collections collectionsList = Collections(data: []);
  Collections userCollectionsList = Collections(data: []);
  List<String> collectionNames = [];

  bool loading = false;

  Future<void> getAllCollections() async {
    loading = true;
    collectionsList = await BackendServices.getCollections();

    loading = false;
    notifyListeners();
  }

  Future<void> getUserCollections() async {
    collectionNames = [];
    loading = true;
    userCollectionsList = await BackendServices.getCurrentUserCollections();
    userCollectionsList.data.forEach((element) {
      collectionNames.add(element.name);
    });
    loading = false;
    notifyListeners();
  }

  void addNewCollectionInList(String value) {
    collectionNames.add(value);
    notifyListeners();
  }
}
