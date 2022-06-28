import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<Map<String,dynamic>> getMyInfos() async {
    return apiAuth.getMyInfos();
  }
  //End of auth methods


  //Users Methods
  Future<Map<String,dynamic>> getUserInfos(int id) async {
    return apiUsers.getUserInfos(id);
  }

  Future<Map<String,dynamic>> getUserResources(int id) async {
    return apiUsers.getUserResources(id);
  }

  Future<Map<String,dynamic>> getUserRelations(int id) async {
    return apiUsers.getUserRelations(id);
  }

  Future<Map<String,dynamic>> updateUserInfos(username, firstname, lastname) async {
    return apiUsers.updateUserInfos(username, firstname, lastname);
  }

  Future<Map<String,dynamic>> updateUserPassword(oldPassword, password) async {
    return apiUsers.updateUserPassword(oldPassword, password);
  }
  //End of users methods

  //Relations Methods
  Future<Map<String,dynamic>> getUserSuggestions() async {
    return apiRelations.getUserSuggestions();
  }

  Future<Map<String,dynamic>> getRequests() async {
    return apiRelations.getRequests();
  }

  Future<Map<String,dynamic>> acceptRequest(requestId) async {
    return apiRelations.acceptRequest(requestId);
  }

  Future<Map<String,dynamic>> denyRequest(requestId) async {
    return apiRelations.denyRequest(requestId);
  }

  Future<Map<String,dynamic>> getRelationWithTheUser(userId) async {
    return apiRelations.getRelationWithTheUser(userId);
  }

  Future<void> sendRelation(userId, type) async {
    return apiRelations.sendRelation(userId, type);
  }

  Future<void> cancelRelation(userId) async {
    return apiRelations.cancelRelation(userId);
  }

  Future<void> removeRelation(userId) async {
    return apiRelations.removeRelation(userId);
  }
  //End of relations methods


  //Ressources Methods
  Future<Map<String,dynamic>> getResources(int page) async {
    return apiResources.getResources(page);
  }

  Future<Map<String,dynamic>> getPopularTags() async {
    return apiResources.getPopularTags();
  }

  Future<void> changeLike(ressourceId, favorite) async {
    return apiResources.changeLike(ressourceId, favorite);
  }

  Future<Map<String,dynamic>> getRessource(id) async {
    return apiResources.getRessource(id);
  }
  //End of resources methods
}