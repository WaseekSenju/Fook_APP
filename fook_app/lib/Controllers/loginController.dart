import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'const.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class LoginController {
  static var client = http.Client();
  static Future<Map<String, String>> loginUser(
      String email, String password) async {
    String _tokken = '';
    String _status = '';
    try {
      var url = Uri.parse('http://54.171.9.121:84/user/login');
      var response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      String data = response.body;
      _tokken = jsonDecode(data)['data']['authToken'];
      _status = response.statusCode.toString();
      Const.setTokken(_tokken);
      return {'tokken': _tokken, 'status': _status};
    } catch (Exception) {
      print(Exception);
      return {'tokken': _tokken, 'status': _status};
    }
  }

  static Future<String> signUpUser(
    File file,
    String email,
    String password,
    String name,
  ) async {
    var dio = Dio();
    String url = 'http://54.171.9.121:84/users';

    FormData formData = new FormData.fromMap({
      "image": MultipartFile(
        file.openRead(),
        await file.length(),
        contentType: new MediaType('image', 'jpeg'),
        filename: '{$name}_image',
      ),
      'username': name,
      'password': password,
      'email': email,
    });
    try {
      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return '201';
      } else {
        return response.data;
      }
    } catch (Exception) {
      print(Exception);
      return '0';
    }
  }

  static Future<String> signUpUserWithoutImage(
    String email,
    String password,
    String name,
  ) async {
    var dio = Dio();
    String url = 'http://54.171.9.121:84/users';

    FormData formData = new FormData.fromMap({
      'username': name,
      'password': password,
      'email': email,
    });
    try {
      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return '201';
      } else {
        return response.data;
      }
    } catch (Exception) {
      print(Exception);
      return '0';
    }
  }
}

//   static Future<String> SignUpUser(
//       String email, String password, String name) async {
//     try {
//       var url = Uri.parse('http://54.171.9.121:84/users');
//       var response = await client.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'username': name,
//           'password': password,
//           'email': email,
//         }),
//       );
//       if (response.statusCode == 201) {
//         return '201';
//       } else {
//         return response.body;
//       }
//     } catch (Exception) {
//       return '0';
//     }
//   }
// }