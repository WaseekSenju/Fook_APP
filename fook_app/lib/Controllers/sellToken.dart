import 'package:dio/dio.dart';
import 'const.dart';

class SellTokenController {
  bool uploading = false;
  static Future<String> setTokenPriceAndAllow(
    String tokenId,
    String collectionId,
    Map<String, String> price,
  ) async {
    String tokken = Const.tokken;
    var dio = Dio();

    String url =
        'http://54.171.9.121:84/collections/$collectionId/tokens/$tokenId/price';

    try {
      var response = await dio.put(
        url,
        data: price,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer $tokken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        return response.data['message'];
      }
    }on DioError catch (e) {
      var res = e.response as dynamic;
      var data = res.data as dynamic;
      return data["message"] ?? 'An error has occurred. Please try again and verify the entered amount is higher than the previous amount.';    }
  }
}
