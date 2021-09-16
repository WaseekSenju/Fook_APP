import 'package:flutter/cupertino.dart';
import '/API/services.dart';
import '/Models/tokken_model.dart';

class AllTokens with ChangeNotifier {
  Tokken tokken = new Tokken(data: []);
  Tokken uploadedtokens = new Tokken(data: []);
  Tokken likedTokens = new Tokken(data: []);
  Tokken acquiredTokens = new Tokken(data: []);

  bool loading = false;

  void addNewCreatedToken(Datum value) {
    tokken.data.add(value);
    uploadedtokens.data.add(value);
    notifyListeners();
  }

  void addNewBoughtTokenInAcquired(Datum value) {
    acquiredTokens.data.add(value);
    notifyListeners();
  }

  Future<void> getAllTokens() async {
    try {
      loading = true;
      tokken = await BackendServices.getTokken().whenComplete(() {});
      tokken.data.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
      loading = false;
    } catch (Exception) {
      print(Exception);
    }

    notifyListeners();
  }

  Future<void> getUploadedtokens() async {
    try {
      loading = true;
      uploadedtokens = await BackendServices.getCurrentUserCreatedTokens();
      loading = false;
    } catch (Exception) {
      print(Exception);
    }
    notifyListeners();
  }

  Future<void> getDownloadedtokens() async {
    try {
      loading = true;
      acquiredTokens = await BackendServices.getCurrentUserAcquiredTokens();
      loading = false;
    } catch (Exception) {
      print('DOnwload tokens bc');
      print(Exception);
    }
    notifyListeners();
  }

  Future<void> getLikedTokens() async {
    try {
      loading = true;
      likedTokens = await BackendServices.getfavouriteToken();
      loading = false;
    } catch (Exception) {
      print(Exception);
    }
    notifyListeners();
  }
}
