import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/card_components/card_notification_friend_request.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/ressources/app_utils.dart';
import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';

class PageNotification extends StatefulWidget {
  const PageNotification({Key? key}) : super(key: key);

  @override
  _PageNotificationState createState() => _PageNotificationState();
}

class _PageNotificationState extends State<PageNotification> {

  @override
  void initState() {
    AppUtils.getUserInfos().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    getFriendRequestsFuture();

    return Scaffold(
      appBar: AppAppbar(
        avatar: AppUtils.getImageLink(AppGlobal.userInfos!.avatar!),
      ),
      endDrawer: AppDrawer(
        mail: AppGlobal.userInfos!.email!
      ),
      body: SingleChildScrollView(
        child: Column (
          children: [
            getFriendRequests(),
            SafePadding()
          ],
        ),
      ),
    );
  }

  Widget getFriendRequests() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: AppText("LOADING", size: 26),);
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return const Center(child: AppText("ERROR", size: 26),);
          }
        }
      },
      future: getFriendRequestsFuture(),
    );
  }

  Future<Widget> getFriendRequestsFuture() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> res = [];

    Map<String, dynamic> mapFriendRequests = await api.getFriendRequests(AppGlobal.userInfos!.email!);

    var jsonData = jsonDecode(mapFriendRequests["body"])["data"];
    for(var data in jsonData) {
      res.add(
        CardNotificationFriendRequest(
          imgLink: AppUtils.getImageLink(data["avatar"]),
          firstname: data["firstName"],
          lastname: data["lastName"],
          mail: data["email"],
          relationType: data["label"],
          relationId: data["_id"],
          callbackReload: reload,
        ),
      );
    }

    return Column(
      children: res,
    );
  }

  void reload() {
    setState(() {});
  }
}
