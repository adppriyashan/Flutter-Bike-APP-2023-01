import 'dart:convert';

import 'package:dio/dio.dart';

class HttpController {
  Future<Response> doPost(String url, Map<String, dynamic> headers,
      Map<String, dynamic> data) async {
    print(url);
    Dio dioConnection = Dio();
    headers.forEach((key, value) {
      dioConnection.options.headers[key] = value;
    });
    return await dioConnection.post(url, queryParameters: data);
  }



  Future<Response> doPostJson(String url, headers,
     data) async {
    Dio dioConnection = Dio();
    return await dioConnection.post(url, options: headers, data:jsonEncode(data) );
  }

  Future<Response> doPostFormData(
      String url, Map<String, dynamic> headers, FormData formData) async {
    print(url);
    Dio dioConnection = Dio();
    headers.forEach((key, value) {
      dioConnection.options.headers[key] = value;
    });
    return await dioConnection.post(url, data: formData);
  }

  Future<Response> doGet(String url, Map<String, dynamic> headers,
      Map<String, dynamic> data) async {
    print(url);
    Dio dioConnection = Dio();
    headers.forEach((key, value) {
      dioConnection.options.headers[key] = value;
    });
    return await dioConnection.get(url, queryParameters: data);
  }
}
