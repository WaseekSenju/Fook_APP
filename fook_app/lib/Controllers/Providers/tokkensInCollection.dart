import 'package:flutter/cupertino.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Models/tokken_model.dart';

class UserTokensController extends ChangeNotifier {
  List<String> collectionIds = [];
  List<Map<String, Tokken>> tokkensList = [];
  Tokken userTokkens = Tokken(data: []);
  Map<String, Tokken> placeHolder = {};

  bool loading = false;

  void getUserTokkens(List<Map<String, String>> collectionIds) async {
    tokkensList = [];
    loading = true;
    Future.wait(collectionIds.map((tokken) =>
            BackendServices.getTokensInCollections(tokken.keys.first)))
        .then((tokkenList) {
      for (int i = 0; i < collectionIds.length; i++) {
        placeHolder = {collectionIds[i].values.first: tokkenList[i]};
        tokkensList.add(placeHolder);
      }
    });
    loading = false;
    notifyListeners();
  }
}
