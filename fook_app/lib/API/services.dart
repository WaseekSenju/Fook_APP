import 'dart:convert';

import '/Models/collections.dart';
import '/Models/tokken_model.dart';
import '/Models/userBalance.dart';

import '../Models/user.dart';
import 'package:http/http.dart' as http;
import '../Controllers/const.dart';

class BackendServices {
  static var client = http.Client();

  static Future<GetUser> getUser() async {
    String tokken = Const.tokken;

    var url = Uri.parse('http://54.171.9.121:84/user');
    var response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokken',
      },
    );

    var jsonString = response.body;
    return getUserFromJson(jsonString);
  }

  static Future<UserBalance> getUserBalance() async {
    String tokken = Const.tokken;

    var url = Uri.parse('http://54.171.9.121:84/user/balance');
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

  static Future<Tokken> getTokken() async {
    String tokken = Const.tokken;
    try {
      var url = Uri.parse('http://54.171.9.121:84/tokens');
      var response = await client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );
      print('http');
      return tokkenFromJson(response.body);
    } catch (Exception) {
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
      return tokkenFromJson(response.body);
    } catch (Exception) {
      return tokkenFromJson('');
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
      return tokkenFromJson(response.body);
    } catch (Exception) {
      return tokkenFromJson('');
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
    } catch (Exception) {
      print(Exception);
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
    } catch (Exception) {
      print(Exception);
      print('getCurrentUserCollectionserror');
      return _userCollections;
    }
  }
}
