import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:france_partage/component/card_components/card_notification_friend_request.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/resources/app_colors.dart';
import '../api/api_france_partage.dart';
import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';
import '../resources/app_utils.dart';

class PageNotification extends StatefulWidget {
  const PageNotification({Key? key}) : super(key: key);

  @override
  _PageNotificationState createState() => _PageNotificationState();
}

class _PageNotificationState extends State<PageNotification> {
  bool loaded = false;

  @override
  void initState() {
    loaded = false;
    AppUtils.getUserInfos().then((value) => setState(() {
      loaded = true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    if(!loaded) {
      return Container();
    } else {
      return Scaffold(
        appBar: AppAppbar(),
        endDrawer: AppDrawer(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 10, left: 10),
              child: AppText("Notifications", size: 34, color: AppColors.DARK_900,)
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  getWidgets(),
                  SafePadding()
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  Widget getWidgets() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return const Text("LOADING");
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return const Text("ERROR");
          }
        }
      },
      future: getRequests(),
    );
  }

  Future<Widget> getRequests() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> requestsList = [];

    requestsList.add(const Padding(padding: EdgeInsets.only(left:2)));

    Map<String, dynamic> mapUserSuggestions = await api.getRequests();
    var jsonData = jsonDecode(mapUserSuggestions["body"])["data"];

    for(var data in jsonData) {
      var user = data["participants"][0];
      for(var participant in data["participants"]) {
        if(participant["id"] != data["requestToId"]) {
          user = participant;
        }
      }

      requestsList.add(
        Padding(
          padding: EdgeInsets.only(left:6, right:6),
          child: CardNotificationFriendRequest(
            requestId: data["id"],
            type: data["type"],
            id: user["id"],
            avatar: user["avatar"],
            displayName: user["displayName"],
            callbackReload: reload,
          ),
        ),
      );

    }

    requestsList.add(const Padding(padding: EdgeInsets.only(right:2)));

    return Row(
      children: requestsList,
    );
  }

  void reload() {
    setState(() {});
  }
}
