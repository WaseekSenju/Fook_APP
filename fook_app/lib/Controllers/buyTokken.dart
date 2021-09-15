import 'dart:convert';

import 'package:http/http.dart' as http;
import 'const.dart';

class BuyTokken {
  static var client = http.Client();
  static Future<String> buyTokken(String collectionId, String tokkenId) async {
    String tokken = Const.tokken;
    try {
      var url = Uri.parse(
          'http://54.171.9.121:84/collections/$collectionId/tokens/$tokkenId/buy');
      var response = await client.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      );

      var _result = jsonDecode(response.body);
      int _status = response.statusCode;

      if (_status == 200) {
        return '200';
      } else {
        return _result['message'];
      }
    } catch (Exception) {
      print(Exception);
      return ' ';
    }
  }
}
