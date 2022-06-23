import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/app_user_infos.dart';

import '../../resources/app_utils.dart';

class ApiUsers {
  final String Url = "http://" + AppUtils.IP;

  //Get User infos by id
  Future<Map<String,dynamic>> getUserInfos(int id) async {
    String completeUrl = Url + "/users/" + id.toString();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  //Get User relations by id
  Future<Map<String,dynamic>> getUserRelations(int id) async {
    String completeUrl = Url + "/users/" + id.toString() + "/relations";

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  //Get User resources by id
  Future<Map<String,dynamic>> getUserResources(int id) async {
    String completeUrl = Url + "/users/" + id.toString() + "/resources";

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }
}