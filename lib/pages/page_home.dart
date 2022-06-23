import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/resources/app_colors.dart';
import 'package:france_partage/resources/app_utils.dart';

import '../component/card_components/card_popular_tags.dart';
import '../component/card_components/card_post.dart';
import '../component/card_components/card_suggestion.dart';
import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/component_safe_padding.dart';
import '../models/app_global.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  bool loaded = false;

  @override
  void initState() {
    loaded = false;
    AppUtils.getUserInfos().then((value) => setState(() {
      loaded = true;
    }));
  }

  List<Widget> allPostsList = [];
  int nbPages = 1;
  int loadedPages = 0;
  bool canLoadMore = false;

  @override
  Widget build(BuildContext context) {
    if(!loaded) {
      return Container();
    } else {
      getContent();

      return Scaffold(
        appBar: AppAppbar(),
        endDrawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSuggestion(),
              CardPopularTags(),
              Column(
                children: allPostsList,
              ),
              getNextPageBtn(),
              SafePadding(
                paddingValue: 14,
              )
            ],
          ),
        ),
        /*
        floatingActionButton: FloatingActionButton(
            onPressed: null,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN ])
              ),
              child: const Icon(Icons.add),
            )
        ),
        */
      );
    }
  }

  Future<void> getContent() async {
    if(loadedPages < nbPages) {
      ApiFrancePartage api = ApiFrancePartage();

      List<Widget> postsList = [];
      Map<String, dynamic> mapContent = await api.getResources(nbPages);

      var jsonData = jsonDecode(mapContent["body"])["data"];

      for(var data in jsonData) {
        List<String> stringTags = [];
        for(var tag in data["tags"]) {
          stringTags.add(tag);
        }

        allPostsList.add(
          CardPost(
            id: data["id"],
            title: data["title"],
            createdAt: DateTime.parse(data["createdAt"]),
            cover: AppUtils.getCoverLink(data["cover"]),
            tags: stringTags, //data["tags"].map((e) => e.toString()).toList()
            favorite: false,
            authorId: data["author"]["id"],
            authorDisplayName: data["author"]["displayName"],
            authorAvatar: AppUtils.getAvatarLink(data["author"]["avatar"])
          ),
        );
      }
      canLoadMore = jsonDecode(mapContent["body"])["pagination"]["hasNextPage"];
      setState(() {
        loadedPages = nbPages;
      });
    }
  }

  Widget getNextPageBtn() {
    print(canLoadMore);
    if(canLoadMore) {
      return Padding(
        padding: EdgeInsets.only(top: 14),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.BLUE,
                    AppColors.CYAN,
                  ],
                )
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              child: AppText(
                "Charger plus",
                size: 16,
                color: AppColors.WHITE,
              ),
            ),
          ),
          onTap: () {
            nbPages++;
            getContent();
          },
        ),
      );
    }
    return Container();
  }
}


