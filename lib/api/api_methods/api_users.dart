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

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
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

  //Update user infos
  Future<Map<String,dynamic>> updateUserInfos(username, firstname, lastname) async {
    String completeUrl = Url + "/users/informations";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    var body = {
      "username": username,
      "firstname": firstname,
      "lastname": lastname
    };

    final jsonString = json.encode(body);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.patch(Uri.parse(completeUrl), headers: headers, body: jsonString);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  //Update user password
  Future<Map<String,dynamic>> updateUserPassword(oldPassword, password) async {
    String completeUrl = Url + "/users/password";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    var body = {
      "oldPassword": oldPassword,
      "newPassword": password
    };

    final jsonString = json.encode(body);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.patch(Uri.parse(completeUrl), headers: headers, body: jsonString);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  // Search Users
  Future<Map<String,dynamic>> searchUsers(String search) async {
    String completeUrl = Url + "/users/search/" + search;

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
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