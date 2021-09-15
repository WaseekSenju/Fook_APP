import 'package:dio/dio.dart';

import 'const.dart';

class LikeTokken {
  static Future<String> likeTokken(String tokenId, String collectionId) async {
    String tokken = Const.tokken;
    var dio = Dio();
    String url =
        'http://54.171.9.121:84/collections/$collectionId/tokens/$tokenId/like';
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      ),
    );
    print('liked');
    print(response.data);
    return response.statusCode.toString();
  }

  static Future<String> unlikeTokken(
      String tokenId, String collectionId) async {
    String tokken = Const.tokken;
    var dio = Dio();
    String url =
        'http://54.171.9.121:84/collections/$collectionId/tokens/$tokenId/like';

    var response = await dio.delete(
      url,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $tokken',
        },
      ),
    );
    print('unliked');
    print(response.data);
    return response.statusCode.toString();
  }
}
