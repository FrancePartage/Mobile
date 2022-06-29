import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api_france_partage.dart';
import '../component/card_components/card_post.dart';
import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';
import '../resources/app_utils.dart';

class PageTagSearch extends StatefulWidget {
  final String search;

  const PageTagSearch({Key? key, required this.search}) : super(key: key);

  @override
  State<PageTagSearch> createState() => _PageTagSearchState();
}

class _PageTagSearchState extends State<PageTagSearch> {
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
                child: AppText("Tag : " + widget.search, size: 26,),
              ),
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
    Map<String, dynamic> mapContent = await api.searchResourcesByTag(widget.search);

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
            favorite: data["liked"],
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
}
