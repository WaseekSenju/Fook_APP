import 'dart:convert';

import 'package:fook_app/Models/Transaction.dart';

import '/Models/collections.dart';
import '/Models/tokken_model.dart';
import '/Models/userBalance.dart';

import '../Models/user.dart' as userInfo;
import 'package:http/http.dart' as http;
import '../Controllers/const.dart';
import 'URLs.dart';

class BackendServices {
  static var client = http.Client();

  static Future<userInfo.GetUser> getUser() async {
    String tokken = Const.tokken;

    var url = Uri.parse(Urls.getUser);
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );
    var jsonString = response.body;
    if (response.statusCode == 200) {
      return userInfo.getUserFromJson(jsonString);
    } else {
      return userInfo.GetUser(
          data: userInfo.Data(id: 0, username: '', image: ''));
    }
  }

  static Future<UserBalance> getUserBalance() async {
    String tokken = Const.tokken;

    var url = Uri.parse(Urls.getUserBalance);
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );

    var jsonString = response.body;
    return userBalanceFromJson(jsonString);
  }

  static Future<String> getUserWalletAddress() async {
    String tokken = Const.tokken;

    var url = Uri.parse(Urls.geWalletAddress);
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );
    String address = json.decode(response.body)['data']['address'];
    print(address);
    return address;
  }

  static Future<Tokken> getTokken() async {
    String tokken = Const.tokken;
    try {
      var url = Uri.parse(Urls.getAllTokens);
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      if (response.statusCode == 200) {
        return tokkenFromJson(response.body);
      } else {
        return Tokken(data: []);
      }
    } catch (exception) {
      return Tokken(data: []);
    }
  }

  static Future<Tokken> getfavouriteToken() async {
    String tokken = Const.tokken;
    try {
      var url = Uri.parse('http://54.171.9.121:84/user/liked-tokens');
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      if (response.statusCode == 200) {
        return tokkenFromJson(response.body);
      } else {
        return Tokken(data: []);
      }
    } catch (exception) {
      return Tokken(data: []);
    }
  }

  static Future<Tokken> getCurrentUserCreatedTokens() async {
    String tokken = Const.tokken;
    var url = Uri.parse('http://54.171.9.121:84/user/created-tokens');
    try {
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      if (response.statusCode == 200) {
        return tokkenFromJson(response.body);
      } else {
        return Tokken(data: []);
      }
    } catch (exception) {
      return Tokken(data: []);
    }
  }

  static Future<Tokken> getCurrentUserAcquiredTokens() async {
    String tokken = Const.tokken;

    var url = Uri.parse('http://54.171.9.121:84/user/acquired-tokens');
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );
    return tokkenFromJson(response.body);
  }

  static Future<Collections> getCollections() async {
    String tokken = Const.tokken;

    var url = Uri.parse('http://54.171.9.121:84/collections');
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );
    return collectionsFromJson(response.body);
  }

  static Future<Tokken> getTokensInCollections(String collectionId) async {
    String tokken = Const.tokken;
    try {
      var url =
          Uri.parse('http://54.171.9.121:84/collections/$collectionId/tokens');
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      if (response.statusCode == 200) {
        return tokkenFromJson(response.body);
      } else {
        print(jsonDecode(response.body)['message']);
        return Tokken(data: []);
      }
    } catch (exception) {
      print(exception);
      print('Something wrong happend');
      return Tokken(data: []);
    }
  }

  static Future<Collections> getCurrentUserCollections() async {
    Collections _userCollections = new Collections(data: []);
    String tokken = Const.tokken;
    var url = Uri.parse('http://54.171.9.121:84/user/collections');
    try {
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        var jsonString = response.body;
        _userCollections = collectionsFromJson(jsonString);
        return _userCollections;
      } else {
        return _userCollections;
      }
    } catch (exception) {
      print(exception);
      print('getCurrentUserCollectionserror');
      return _userCollections;
    }
  }

  static Future<Transaction> getTokenTransaction(
      String tokenId, String collectionId) async {
    Transaction _tokenTransaction = new Transaction(data: []);
    String tokken = Const.tokken;
    var url = Uri.parse(
        'http://54.171.9.121:84/collections/$collectionId/tokens/$tokenId/transactions');
    try {
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        _tokenTransaction = transactionFromJson(jsonString);
        return _tokenTransaction;
      } else {
        return _tokenTransaction;
      }
    } catch (exception) {
      print(exception);
      print('getCurrentUserCollectionserror');
      return _tokenTransaction;
    }
  }
}
