import 'dart:io';
import 'dart:convert';
import 'package:france_partage/api/api_methods/api_resources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:france_partage/api/api_methods/api_auth.dart';
import 'package:france_partage/api/api_methods/api_users.dart';
import 'package:france_partage/api/api_methods/api_relations.dart';

import 'package:france_partage/models/app_user_infos.dart';
import 'package:france_partage/resources/app_utils.dart';

class ApiFrancePartage {
  final String Url = "http://" + AppUtils.IP;

  final ApiAuth apiAuth = ApiAuth();
  final ApiUsers apiUsers = ApiUsers();
  final ApiRelations apiRelations = ApiRelations();
  final ApiResources apiResources = ApiResources();

  //Auth Methods
  Future<Map<String,dynamic>> register({required String mail, required String password, required String username, required String firstname, required String lastname, required bool acceptRgpd}) async {
    return apiAuth.register(mail: mail, password: password, username: username, firstname: firstname, lastname: lastname, acceptRgpd: acceptRgpd);
  }

  Future<Map<String,dynamic>> login({required String mail, required String password}) async {
    return apiAuth.login(mail: mail, password: password);
  }

  Future<void> logout() async {
    apiAuth.logout();
  }

  Future<AppUserInfos?> getActualUserInfos() async {
    return apiAuth.getActualUserInfos();
  }
  //End of auth methods


  //Users Methods
  Future<Map<String,dynamic>> getUserInfos(int id) async {
    return apiUsers.getUserInfos(id);
  }
  //End of users methods

  //Relations Methods
  Future<Map<String,dynamic>> getUserSuggestions() async {
    return apiRelations.getUserSuggestions();
  }
  //End of relations methods


  //Ressources Methods
  Future<Map<String,dynamic>> getResources(int page) async {
    return apiResources.getResources(page);
  }
  //End of resources methods
}







  /*
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
  */

  //getUserRessources

  /*
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
  */

  /*
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
  */

  /*
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
  */

  /*
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
  */
