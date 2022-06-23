import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/app_user_infos.dart';

import '../../resources/app_utils.dart';

class ApiResources {
  final String Url = "http://" + AppUtils.IP;

  Future<Map<String,dynamic>> getResources(int page) async {
    String completeUrl = Url + "/resources?page=" + page.toString();

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    if(response.statusCode == 200) {
      return {
        "code": 200,
        "body": jsonDecode(jsonEncode(response.body))
      };
    }

    return {
      "code": response.statusCode,
      "body": response.body
    };
  }

  Future<Map<String,dynamic>> getPopularTags() async {
    String completeUrl = Url + "/resources/tags";

    //const storage = FlutterSecureStorage();
    //String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      //'Authorization': "Bearer " + accessToken!
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    if (response.statusCode == 200) {
      return {
        "code": 200,
        "body": jsonDecode(jsonEncode(response.body))
      };
    }

    return {
      "code": response.statusCode,
      "body": response.body
    };
  }
}