import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/app_user_infos.dart';

import '../../resources/app_utils.dart';

class ApiRelations {
  final String Url = "http://" + AppUtils.IP;

  //Get user suggestions
  Future<Map<String,dynamic>> getUserSuggestions() async {
    String completeUrl = Url + "/relations/suggestions";

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

  //Get relation requests
  Future<Map<String,dynamic>> getRequests() async {
    String completeUrl = Url + "/relations/requests";

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

  //Accept a relation request
  Future<Map<String,dynamic>> acceptRequest(requestId) async {
    String completeUrl = Url + "/relations/request/accept";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    var body = {
      "requestId":requestId
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

  //Deny a relation request
  Future<Map<String,dynamic>> denyRequest(requestId) async {
    String completeUrl = Url + "/relations/request/deny";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    var body = {
      "requestId":requestId
    };

    final jsonString = json.encode(body);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.delete(Uri.parse(completeUrl), headers: headers, body: jsonString);

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