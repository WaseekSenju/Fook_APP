import 'dart:io';

import 'package:fook_app/API/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

import 'const.dart';

class NewTokenAndCollection {
  bool uploading = false;
  static Future<String> newTokken(XFile file, String name, String description,
      String price, String id) async {
    String fileName = file.path.split('/').last;
    String tokken = Const.tokken;
    var dio = Dio();
    String url = 'http://54.171.9.121:84/collections/$id/tokens';
    FormData formData = new FormData.fromMap({
      "file": MultipartFile(
        file.openRead(),
        await file.length(),
        contentType: new MediaType('image', 'jpeg'),
        filename: fileName,
      ),
      'thumbnail': MultipartFile(
        file.openRead(),
        await file.length(),
        contentType: new MediaType('image', 'jpeg'),
        filename: fileName,
      ),
      'name': name,
      'price': price,
      'unitPrice': 'ether',
      'description': description,
    });
    try {
      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'application/json',
            'Authorization': 'Bearer $tokken',
          },
        ),
      );
      if (response.statusCode == 201) {
        return response.statusCode.toString();
      } else {
        return response.data;
      }
    } catch (Exception) {
      return '0';
    }
  }

  static Future<String> createNewCollection(
      File file, String name, String symbol) async {
    String fileName = file.path.split('/').last;
    String tokken = Const.tokken;
    var dio = Dio();
    String url = 'http://54.171.9.121:84/collections';
    FormData formData = new FormData.fromMap({
      "image": MultipartFile(
        file.openRead(),
        await file.length(),
        contentType: new MediaType('image', 'jpeg'),
        filename: fileName,
      ),
      'name': name,
      'symbol': symbol,
    });
    try {
      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'application/json',
            'Authorization': 'Bearer $tokken',
          },
        ),
      );
      if (response.statusCode == 201) {
        return response.statusCode.toString();
      } else {
        return response.data;
      }
    }  catch  (Exception) {
      return 'Error in Collection Creation';
    }
  }
}
