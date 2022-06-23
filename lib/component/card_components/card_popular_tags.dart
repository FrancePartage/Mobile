import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_tag.dart';

import '../../api/api_france_partage.dart';
import '../text_components/app_text.dart';

class CardPopularTags extends StatefulWidget {
  const CardPopularTags({Key? key}) : super(key: key);

  @override
  State<CardPopularTags> createState() => _CardPopularTagsState();
}

class _CardPopularTagsState extends State<CardPopularTags> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Center(
          child: Card(
            elevation: 4,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 6),
                        child: AppText(
                          "Tags",
                          size: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: getWidgets()
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
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
      future: getPopularTags(),
    );
  }

  Future<Widget> getPopularTags() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> tagsList = [];

    tagsList.add(const Padding(padding: EdgeInsets.only(left:2)));

    Map<String, dynamic> mapPopularTags = await api.getPopularTags();
    var jsonData = jsonDecode(mapPopularTags["body"])["data"];

    for(var data in jsonData) {
      tagsList.add(
        Padding(
          padding: EdgeInsets.only(left:6, right:6),
          child: AppTag(
            tag: data["tag"],
          ),
        ),
      );
    }

    tagsList.add(const Padding(padding: EdgeInsets.only(right:2)));

    return Row(
      children: tagsList,
    );
  }
}
