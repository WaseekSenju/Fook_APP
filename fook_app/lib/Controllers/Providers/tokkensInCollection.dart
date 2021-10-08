import 'package:flutter/cupertino.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:provider/provider.dart';

class UserTokensController extends ChangeNotifier {
  List<String> collectionIds = [];
  List<Map<String, Tokken>> tokkensList = [];
  //Tokken userTokkens = Tokken(data: []);
  Map<String, Tokken> placeHolder = {};
  Tokken singleCollectionToken = Tokken(data: []);

  bool loading = false;

  void getUserTokkens(List<Map<String, String>> collectionIds) async {
    tokkensList = [];
    loading = true;
    BackendServices.getTokken().then((searchScreenTokens) {
      for (int i = 0; i < collectionIds.length; i++) {
        // for the collection name
        for (int j = 0; j < searchScreenTokens.data.length; j++) {
          String currentTokenName = searchScreenTokens.data[j].collection.name;
          if (currentTokenName == collectionIds[i].values.first) {
            singleCollectionToken.data.add(searchScreenTokens.data[j]);
          }
        }
        placeHolder = {collectionIds[i].values.first: singleCollectionToken};
        tokkensList.add(placeHolder);
        singleCollectionToken = Tokken(data: []);
      }
      loading = false;
      notifyListeners();
    });

    // BackendServices.getTokken().then((searchScreenTokens) {
    //   collectionIds.forEach((collectionId) {
    //     print(collectionIds.first);
    //     searchScreenTokens.data.forEach((singleToken) {
    //       if (singleToken.id == collectionId.values.first) {
    //         print(collectionId.values.first);
    //         singleCollectionToken.first.data.add(singleToken);
    //         print(singleToken.name);
    //       }
    //     });
    //     placeHolder = {collectionId.values.first: singleCollectionToken.first};
    //     tokkensList.add(placeHolder);
    //   });
    // });

    // Future.wait(collectionIds.map((tokken) =>
    //         BackendServices.getTokensInCollections(tokken.keys.first)))
    //     .then((tokkenList) {
    //   for (int i = 0; i < collectionIds.length; i++) {
    //     placeHolder = {collectionIds[i].values.first: tokkenList[i]};
    //     tokkensList.add(placeHolder);
    //   }
    // });
    // loading = false;
    // notifyListeners();
  }
}
