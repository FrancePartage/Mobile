import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/card_components/card_post.dart';
import 'package:france_partage/component/component_app_appbar.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/models/app_user_infos.dart';

import '../component/card_components/card_profile_summary.dart';
import '../component/card_components/card_relation.dart';
import '../component/component_app_drawer.dart';
import '../models/app_global.dart';
import '../resources/app_utils.dart';

class PageUserProfile extends StatefulWidget {
  final int id;
  String? selectedTab;
  PageUserProfile({Key? key, required this.id}) : super(key: key) {
    selectedTab = "resources";
  }

  @override
  _PageUserProfileState createState() => _PageUserProfileState();
}

class _PageUserProfileState extends State<PageUserProfile> {

  dynamic infos = null;

  @override
  void initState() {
    AppUtils.getUserInfos().then((value) =>
      getProfileInfos().then((value) =>
        getResources().then((value) =>
          setState(() {})
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
      endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getProfileCard(),
            getContent(),
            SafePadding()
          ],
        ),
      ),
    );
  }

  void reload() {
    setState(() {});
  }

  Future<void> getProfileInfos() async{
    ApiFrancePartage api = ApiFrancePartage();

    Map<String, dynamic> mapInfos = await api.getUserInfos(widget.id);
    var dataInfos = jsonDecode(mapInfos["body"]);

    infos = dataInfos;
    setState(() {});
  }

  Widget getProfileCard() {
    if(infos == null) {
      return const Center(
        child: Text("LOADING"),
      );
    } else {
      return CardProfileSummary(
        id: infos["id"],
        username: infos["displayName"],
        avatar: AppUtils.getAvatarLink(infos["avatar"]),
        nbRessources: infos["resourcesCount"],
        nbRelations: infos["relationsCount"],
        callback: changeTab,
        selectedTab: widget.selectedTab!,
        callbackReload: reload,
      );
    }
  }

  Widget getContent() {
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
      future: (widget.selectedTab == "resources") ? getResources() : getRelations(),
    );
  }

  Future<Widget> getResources() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> res = [];

    res.add(
        SizedBox(height: 10,)
    );

    Map<String,dynamic> mapResources = await api.getUserResources(infos["id"]);
    dynamic jsonData = jsonDecode(mapResources["body"])["data"];

    for(var data in jsonData) {
      List<String> stringTags = [];
      for(var tag in data["tags"]) {
        stringTags.add(tag);
      }

      res.add(
        CardPost(
            id: data["id"],
            title: data["title"],
            createdAt: DateTime.parse(data["createdAt"]),
            cover: AppUtils.getCoverLink(data["cover"]),
            tags: stringTags,
            favorite: data["liked"],
            authorId: data["author"]["id"],
            authorDisplayName: data["author"]["displayName"],
            authorAvatar: AppUtils.getAvatarLink(data["author"]["avatar"])
        ),
      );
    }

    return Column(
      children: res,
    );
  }

  Future<Widget> getRelations() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> res = [];

    res.add(
      SizedBox(height: 10,)
    );

    Map<String,dynamic> mapRelations = await api.getUserRelations(infos["id"]);
    dynamic jsonData = jsonDecode(mapRelations["body"])["data"];
    for(var data in jsonData) {
      var user = data["participants"][0];
      for (var participant in data["participants"]) {
        if (participant["id"] != data["requestToId"]) {
          user = participant;
        }
      }

      res.add(
        CardRelation(
          type: data["type"],
          id: user["id"],
          avatar: user["avatar"],
          displayName: user["displayName"],
        )
      );
    }

    return Column(
      children: res,
    );
  }

  void changeTab(String tab) {
    if(widget.selectedTab == tab) {
      return;
    }
    setState(() {
      widget.selectedTab = tab;
    });
  }
}
