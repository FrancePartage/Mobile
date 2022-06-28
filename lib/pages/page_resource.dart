import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/card_components/card_complete_post.dart';
import 'package:france_partage/component/card_components/card_post.dart';

import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../resources/app_utils.dart';

class PageResource extends StatefulWidget {
  final int id;
  const PageResource({Key? key, required this.id}) : super(key: key);

  @override
  State<PageResource> createState() => _PageResourceState();
}

class _PageResourceState extends State<PageResource> {
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
              getWidget()
            ],
          )
      );
    }
  }

  Widget getWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("LOADING"),);
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return const Center(child: Text("ERROR"),);
          }
        }
      },
      future: getPost(),
    );
  }

  Future<Widget> getPost() async {
    ApiFrancePartage api = ApiFrancePartage();
    Map<String,dynamic> mapResource = await api.getRessource(widget.id);
    dynamic jsonData = jsonDecode(mapResource["body"])["data"];

    //print(jsonData);

    List<String> stringTags = [];
    for(var tag in jsonData["tags"]) {
      stringTags.add(tag);
    }

    return CardCompletePost(
        id: jsonData["id"],
        title: jsonData["title"],
        createdAt: DateTime.parse(jsonData["createdAt"]),
        tags: stringTags,
        content: jsonData["content"],
        favorite: jsonData["liked"],
        authorId: jsonData["author"]["id"],
        authorDisplayName: jsonData["author"]["displayName"],
        authorAvatar: AppUtils.getAvatarLink(jsonData["author"]["avatar"])
    );

    /*
    return CardCompletePost(
      id: jsonData["id"],
      title: jsonData["title"],
      createdAt: jsonData["createdAt"],
      tags: stringTags,
      favorite: jsonData["liked"],
      authorId: jsonData["author"]["id"],
      authorDisplayName: jsonData["author"]["displayName"],
      authorAvatar: AppUtils.getAvatarLink(jsonData["author"]["avatar"])
    );
    */
  }
}
