import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/component_app_appbar.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/models/app_user_infos.dart';

import '../component/card_components/card_profile_summary.dart';
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
  List<Widget> resourcesList = [];
  List<Widget> relationsList = [];

  @override
  void initState() {
    AppUtils.getUserInfos().then((value) =>
      getProfileInfos().then((value) =>
        setState(() {})
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
            Column(
              children: getContent(),
            ),
            SafePadding()
          ],
        ),
      ),
    );
  }

  Future<void> getProfileInfos() async{
    ApiFrancePartage api = ApiFrancePartage();

    Map<String, dynamic> mapInfos = await api.getUserInfos(widget.id);
    var dataInfos = jsonDecode(mapInfos["body"]);

    infos = dataInfos;
    //await getRelations();
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
          nbRessources: 0,//infos["resourcesCount"],
          nbRelations: 0, //infos["relationsCount"],
          callback: changeTab,
          selectedTab: widget.selectedTab!
      );
    }
  }

  List<Widget> getContent() {
    if(widget.selectedTab == "resources") {
      return resourcesList;
    }
    if(widget.selectedTab == "relations") {
      return relationsList;
    }
    return [];
  }

  Future<void> getRessources() async {
    List<Widget> res = [];

    resourcesList =  res;
  }

  /*
  Future<void> getRelations() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> res = [];

    res.add(
      SizedBox(height: 10,)
    );

    Map<String,dynamic> mapRelations = await api.getUserRelations(widget.id);
    dynamic jsonData = jsonDecode(mapRelations["body"])["data"];

    for(var data in jsonData) {
      res.add(
        CardRelation(
          avatar: AppUtils.getImageLink(data["avatar"]),
          firstname: data["firstName"],
          lastname: data["lastName"],
          mail: data["email"],
          relationType: data["label"]
        )
      );
    }

    /*
    res.add(CardRelation(
      avatar: "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
      firstname: "Theo",
      lastname: "Cousinard",
      mail: "theo.cousinard@viacesi.fr",
      relationType: "Conjoint",
    ));

    res.add(CardRelation(
      avatar: "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
      firstname: "Theo",
      lastname: "Cousinard",
      mail: "theo.cousinard@viacesi.fr",
      relationType: "Ami",
    ));
     */

    relationsList = res;
  }

   */

  void changeTab(String tab) {
    if(widget.selectedTab == tab) {
      return;
    }
    setState(() {
      widget.selectedTab = tab;
    });
  }
}
