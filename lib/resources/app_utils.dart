import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/models/app_user_infos.dart';

class AppUtils {
  static const String IP = "192.168.0.16:3333";

  // To get the good link to display an avatar
  static String getAvatarLink(String link) {
    return "http://" + IP + "/assets/avatars/" + link;
  }

  // To get the good link to display a cover
  static String getCoverLink(String link) {
    return "http://" + IP + "/assets/covers/" + link;
  }

  // To get Infos on the actual User
  static Future<void> getUserInfos() async {
    ApiFrancePartage api = ApiFrancePartage();
    AppUserInfos? userInfos = await api.getActualUserInfos();

    AppGlobal.userInfos = userInfos;
  }

  // To get time in the wanted format with the date
  static String getDateDifference(DateTime date) {
    String res = "Il y a ";
    DateTime dateNow = DateTime.now();
    Duration difference = dateNow.difference(date);

    //Years
    if(difference.inDays > 365) {
      int yearsDiff = (difference.inDays / 365.25).floor();
      return res + yearsDiff.toString() + " an" + (yearsDiff > 1 ? "s" : "");
    }
    //Months
    if(difference.inDays > 30) {
      int monthsDif = (difference.inDays / 30.44).floor();
      return res + monthsDif.toString() + " mois";
    }
    //Days
    if(difference.inDays > 0) {
      return res + difference.inDays.toString() + " jour" + (difference.inDays > 1 ? "s" : "");
    }
    //Hours
    if (difference.inHours > 0) {
      return res + difference.inHours.toString() + " heure" + (difference.inHours > 1 ? "s" : "");
    }
    //Minutes
    if (difference.inMinutes > 0) {
      return res + difference.inMinutes.toString() + " minute" + (difference.inMinutes > 1 ? "s" : "");
    }
    //Seconds
    return res + difference.inSeconds.toString() + " seconde" + (difference.inSeconds > 1 ? "s" : "");
  }

  static String getRequestTypeName(String type) {
    switch(type) {
      case "FRIEND":
        return "Ami";
      case "SPOUSE":
        return "Conjoint";
      case "WORKMATE":
        return "Collègue";
      case "FAMILY":
        return "Famille";
      default:
        return type;
    }
  }
}