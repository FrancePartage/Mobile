import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:france_partage/models/app_user_infos.dart';
import 'package:france_partage/ressources/app_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiFrancePartage {
  final String Url = "http://" + AppUtils.IP + "/api";

  //Auth
  Future<Map<String,dynamic>> login({required String mail, required String password}) async {
    String completeUrl = Url + "/auth/login";
    var body = {
      "email":mail,
      "password":password
    };

    final jsonString = json.encode(body);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

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

  Future<Map<String,dynamic>> register({required String mail, required String password, required String firstname, required String lastname}) async {
    String completeUrl = Url + "/auth/register";
    var body = {
      "email":mail,
      "password":password,
      "firstName":firstname,
      "lastName":lastname
    };

    final jsonString = json.encode(body);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

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

  Future<AppUserInfos?> getActualUserInfos() async {
    String completeUrl = Url + "/auth/me";

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
    };

    final response = await http.get(Uri.parse(completeUrl), headers: headers);

    if(response.statusCode == 200) {
      AppUserInfos userInfos = AppUserInfos.fromJson(jsonDecode(response.body)["data"]);
      return userInfos;
    }

    return null;
  }


  //Home page
  Future<Map<String,dynamic>> getUserSuggestions() async {
    String completeUrl = Url + "/relations/peopleMightKnow";

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
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

  Future<Map<String,dynamic>> getHomePageContent(int page) async {
    String completeUrl = Url + "/resources?page=" + page.toString();

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
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


  // Profile page
  Future<Map<String,dynamic>> getProfileInfos(String email) async {
    String completeUrl = Url + "/users/" + email;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
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

  //getRessources

  Future<Map<String,dynamic>> getUserRelations(String email) async {
    String completeUrl = Url + "/relations/" + email;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
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

  // Notification Page
  Future<Map<String,dynamic>> getFriendRequests(String email) async {
    String completeUrl = Url + "/relations/requests";

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
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

  //accept request  acceptFriendRequest
  Future<Map<String,dynamic>> acceptFriendRequest(String id) async {
    String completeUrl = Url + "/relations/accept";

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
    };

    var body = {
      "relationId":id
    };

    final jsonString = json.encode(body);

    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

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

  Future<Map<String,dynamic>> denyFriendRequest(String id) async {
    String completeUrl = Url + "/relations/deny";

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'x-access-token': token!
    };

    var body = {
      "relationId":id
    };

    final jsonString = json.encode(body);

    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

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
}