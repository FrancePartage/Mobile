import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

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

  // Get most used tags
  Future<Map<String,dynamic>> getPopularTags() async {
    String completeUrl = Url + "/resources/tags";

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
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

  //Like or Dislike a ressource
  Future<void> changeLike(ressourceId, favorite) async {
    String completeUrl = Url + "/resources/first/" + ressourceId.toString() + "/like";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    if(favorite) {
      await http.delete(Uri.parse(completeUrl), headers: headers);
    } else {
      await http.post(Uri.parse(completeUrl), headers: headers);
    }
  }

  // Get ressource data
  Future<Map<String,dynamic>> getRessource(id) async {
    String completeUrl = Url + "/resources/first/" + id.toString();

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
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

  // Get a ressource comments
  Future<Map<String,dynamic>> getComments(id) async {
    String completeUrl = Url + "/resources/first/" + id.toString() + "/comments";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
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

  Future<Map<String,dynamic>> addComment(id, comment) async {
    String completeUrl = Url + "/resources/first/" + id.toString() + "/comments";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    var body = {
      "content": comment
    };

    final jsonString = json.encode(body);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    final response = await http.post(Uri.parse(completeUrl), headers: headers, body: jsonString);

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

  // Send a post
  Future<Map<String,dynamic>> postRessource(title, tags, coverXFile, content) async {
    String completeUrl = Url + "/resources";

    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'Authorization': "Bearer " + accessToken!
    };

    print(coverXFile.path);
    File coverFile = File(coverXFile.path);

    var postUri = Uri.parse(completeUrl);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(headers);

    Map<String, String> tagsArray = {
      for (var i = 0; i < tags.length; i++) 'fields[0][tags][$i]': tags[i]
    };
    request.fields.addAll({
      ...tagsArray,
      'fields[0][title]': title,
      'fields[0][content]': content,
    });
    print(request.fields);
    request.files.add(new http.MultipartFile.fromBytes('coverFile', await File.fromUri(Uri.parse(coverFile.path)).readAsBytes(), contentType: new MediaType('image', 'jpeg')));

    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response);
    }

    return {
      "code": 200,
      "body": jsonEncode("Testing")
    };
  }

  // Search resources
  Future<Map<String,dynamic>> searchResources(String search) async {
    String completeUrl = Url + "/resources/search/" + search;

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

  // Search resources by tag
  Future<Map<String,dynamic>> searchResourcesByTag(String search) async {
    String completeUrl = Url + "/resources/tags/" + search;

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
}