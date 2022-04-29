import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/card_components/card_suggestion.dart';
import 'package:france_partage/component/card_components/card_post.dart';
import 'package:france_partage/component/component_app_appbar.dart';
import 'package:france_partage/component/component_app_drawer.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/ressources/app_colors.dart';
import 'package:france_partage/ressources/app_utils.dart';

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
  bool canLoadMore = true;

  @override
  Widget build(BuildContext context) {
    if(!loaded) {
      return Container();
    } else {
      return Scaffold(
        appBar: AppAppbar(
          avatar: AppUtils.getImageLink(AppGlobal.userInfos!.avatar!),
        ),
        endDrawer: AppDrawer(
          mail: AppGlobal.userInfos!.email!,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSuggestion(),
              loadContent(),
              SafePadding()
            ],
          ),
        ),
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
      );
    }
  }

  Future<void> getHomePageContent(int nbPages) async {
    if(loadedPages < nbPages) {
      ApiFrancePartage api = ApiFrancePartage();

      List<Widget> postsList = [];
      Map<String, dynamic> mapContent = await api.getHomePageContent(nbPages);

      var jsonData = jsonDecode(mapContent["body"])["data"];

      for(var data in jsonData["docs"]) {
        allPostsList.add(
          CardPost(
            avatar: AppUtils.getImageLink(data["author"]["avatar"]),
            firstname: data["author"]["firstName"],
            lastname: data["author"]["lastName"],
            mail: data["author"]["email"],
            content: data["content"],
            nbComments: 4,
            like: false
          )
        );
      }
      loadedPages = nbPages;
    }
  }

  Future<Widget> getContent() async {
    await getHomePageContent(nbPages);
    return Column(
      children: allPostsList,
    );
  }

  Widget loadContent() {
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
      future: getContent(),
    );
  }
}


