import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/card_components/card_comment.dart';
import 'package:france_partage/component/card_components/card_complete_post.dart';
import 'package:france_partage/component/card_components/card_post.dart';
import 'package:france_partage/component/component_safe_padding.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/models/app_global.dart';

import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_textfield.dart';
import '../resources/app_colors.dart';
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                getPostBuilder(),
                getCommentsBuilder(),
                SafePadding()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addComment,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN ])
              ),
              child: const Icon(Icons.add_comment),
            )
          ),
      );
    }
  }

  Widget getPostBuilder() {
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
  }

  Widget getCommentsBuilder() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return const Center(child: Text("ERROR"),);
          }
        }
      },
      future: getComments(),
    );
  }

  Future<Widget> getComments() async {
    ApiFrancePartage api = ApiFrancePartage();
    Map<String,dynamic> mapResource = await api.getComments(widget.id);
    dynamic jsonData = jsonDecode(mapResource["body"])["data"];

    List<Widget> comments = [];

    if(jsonData.length > 0) {
      comments.add(
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(child: AppText("Commentaires", size: 20),),
        ),
      );
    }

    for(var data in jsonData) {
      comments.add(
        CardComment(
          authorId: data["author"]["id"],
          authorDisplayName: data["author"]["displayName"],
          authorAvatar: AppUtils.getAvatarLink(data["author"]["avatar"]),
          createdAt: DateTime.parse(data["createdAt"]),
          content: data["content"]
        )
      );
    }

    return Column(children: comments,);
  }

  void addComment() {
    TextEditingController commentCtrl = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Commenter'),
        content: AppTextField(labelText: "Commentaire", hintText: "", textController: commentCtrl),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Annuler');
            },
            child: const AppText(
              "Annuler",
              size: 20,
              color: AppColors.DARK_800,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Valider');
              postComment(commentCtrl.text);
            },
            child: const AppText(
              "Valider",
              size: 20,
              color: AppColors.BLUE,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postComment(comment) async {
    ApiFrancePartage api = ApiFrancePartage();
    await api.addComment(widget.id, comment);
    setState(() {});
  }
}
