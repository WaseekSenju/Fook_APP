import 'package:flutter/cupertino.dart';
import '/API/services.dart';
import '/Models/userBalance.dart';
import '/Models/user.dart' as user;

class UserData with ChangeNotifier {
  bool loading = false;
  user.GetUser userData =
      new user.GetUser(data: new user.Data(id: 1, username: '', image: ''));
  UserBalance userBalance = new UserBalance(
      data: Data(
    unit: '',
    value: '',
  ));
  Future<void> getUserData() async {
    try {
      loading = true;
      userData = await BackendServices.getUser().whenComplete(() {});
      loading = false;
    } catch (exception) {
      print('UserData exception');
      print(exception);
    }
    notifyListeners();
  }

  Future<void> getUserWallet() async {
    try {
      loading = true;
      userBalance = await BackendServices.getUserBalance().whenComplete(() {});
      loading = false;
    } catch (exception) {
      print('User Wallet Exception');
      print(exception);
    }
    notifyListeners();
  }
}
