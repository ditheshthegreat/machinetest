import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ditheshv/REST/app_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

typedef CustomResponse = Function(Map<String, dynamic> response, String error);

class RestAPI {
  Future checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(APis.superLink);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    Map<String, String> headers = {"Accept": "application/json"};
    print('Api Get,headers: $headers url $url');
    Map<String, dynamic> responseJson;
    try {
      Response response = await http.get(url, headers: headers);
      print('Api Get, url $url');
      print('RESPONSE => ${response.body}');
      responseJson = _returnResponse(response);
    } on SocketException {
      print('SocketException');
      throw FetchDataException('Either network issue nor server error');
    } on TimeoutException {
      print('TimeoutException');
      throw FetchDataException('Time out try again');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    print('StatusCode :: ${response.statusCode}');
    switch (response.statusCode) {

      case 200:
        Map<String, dynamic> responseJson = json.decode(response.body);
        return responseJson;
      case 404:
      case 400:
        throw BadRequestException(json.decode(response.body));
        break;
      case 401:
      case 403:
        throw UnauthorisedException(json.decode(response.body));
        break;
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class APis {
  static String superLink = "https://api.github.com";

  static String getUser(String username) => "$superLink/users/$username";
}
