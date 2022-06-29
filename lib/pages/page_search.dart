import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';

import '../api/api_france_partage.dart';
import '../component/card_components/card_post.dart';
import '../component/card_components/card_relation.dart';
import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../resources/app_colors.dart';
import '../resources/app_utils.dart';

class PageSearch extends StatefulWidget {
  final String search;

  const PageSearch({Key? key, required this.search}) : super(key: key);

  @override
  State<PageSearch> createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
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
    if (!loaded) {
      return Container();
    } else {
      return Scaffold(
        appBar: AppAppbar(),
        endDrawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: AppText("Recherche : " + widget.search, size: 26,),
              ),
              getUsersWidget(),
              getPostWidget(),
            ],
          ),
        ),
      );
    }
  }

  Widget getPostWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Center(child: const Text("LOADING"),);
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return Center(child: const Text("ERROR"),);
          }
        }
      },
      future: getSearchResultsPosts(),
    );
  }

  Future<Widget> getSearchResultsPosts() async {
    ApiFrancePartage api = ApiFrancePartage();

    List<Widget> postsList = [];
    Map<String, dynamic> mapContent = await api.searchResources(widget.search);

    var jsonData = jsonDecode(mapContent["body"])["data"];

    for(var data in jsonData) {
      List<String> stringTags = [];
      for(var tag in data["tags"]) {
        stringTags.add(tag);
      }

      postsList.add(
        CardPost(
          id: data["id"],
          title: data["title"],
          createdAt: DateTime.parse(data["createdAt"]),
          cover: AppUtils.getCoverLink(data["cover"]),
          tags: stringTags,
          authorId: data["author"]["id"],
          authorDisplayName: data["author"]["displayName"],
          authorAvatar: AppUtils.getAvatarLink(data["author"]["avatar"])
        ),
      );
    }

    return Column(
      children: postsList,
    );
  }

  Widget getUsersWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Center(child: const Text("LOADING"),);
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return Center(child: const Text("ERROR"),);
          }
        }
      },
      future: getSearchResultsUsers(),
    );
  }

  Future<Widget> getSearchResultsUsers() async {
    ApiFrancePartage api = ApiFrancePartage();

    List<Widget> usersList = [];
    Map<String, dynamic> mapContent = await api.searchUsers(widget.search);
    var jsonData = jsonDecode(mapContent["body"])["data"];
    
    for(var data in jsonData) {
      usersList.add(
        CardRelation(
          id: data["id"],
          avatar: data["avatar"],
          displayName: data["displayName"],
        )
      );
    }

    if(usersList.length > 0) {
      usersList.add(
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 12),
            child: Container(
              color: AppColors.DARK_600,
              height: 1,
            ),
          )
      );
      return Column(
        children: usersList,
      );
    }
    return Container();
  }
}