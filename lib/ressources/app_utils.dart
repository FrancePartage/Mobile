import 'package:flutter/cupertino.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/models/app_user_infos.dart';

class AppUtils {
  static const String IP = "10.176.131.17:3000";

  // To get the good link to display an image
  static String getImageLink(String link) {
    return "http://" + IP + "/images/" + link;
  }

  // To get Infos on the actual User
  static Future<void> getUserInfos() async {
    ApiFrancePartage api = ApiFrancePartage();
    AppUserInfos? userInfos = await api.getActualUserInfos();
    AppGlobal.userInfos = userInfos;
  }
}