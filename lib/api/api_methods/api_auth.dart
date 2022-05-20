import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/app_user_infos.dart';

import '../../resources/app_utils.dart';

class ApiAuth {
  final String Url = "http://" + AppUtils.IP;

  //Register a user
  Future<Map<String,dynamic>> register({required String mail, required String password, required String username, required String firstname, required String lastname, required bool acceptRgpd}) async {
    String completeUrl = Url + "/auth/local/signup";
    var body = {
      "email":mail,
      "password":password,
      "username":username,
      "firstname":firstname,
      "lastname":lastname,
      "acceptRgpd":acceptRgpd
    };

    final jsonString = json.encode(body);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  //Log-in a user
  Future<Map<String,dynamic>> login({required String mail, required String password}) async {
    String completeUrl = Url + "/auth/local/signin";
    var body = {
      "email":mail,
      "password":password
    };

    final jsonString = json.encode(body);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

    var responseBody = response.body;
    if(response.statusCode == 200) {
      var responseBody = jsonDecode(jsonEncode(response.body));
    }

    return {
      "code": response.statusCode,
      "body": responseBody
    };
  }

  //Log-out a user, disable his refreshToken
  Future<void> logout() async {
    String completeUrl = Url + "/auth/logout";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    await http.post(Uri.parse(completeUrl), headers: headers);
  }

  //Get infos of logged user
  Future<AppUserInfos?> getActualUserInfos() async {
    String completeUrl = Url + "/auth/me";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    if(response.statusCode == 200) {
      AppUserInfos userInfos = AppUserInfos.fromJson(jsonDecode(response.body));
      return userInfos;
    }

    return null;
  }
}