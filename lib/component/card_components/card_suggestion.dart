import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/resources/app_utils.dart';
import '../../api/api_france_partage.dart';
import '../../component/component_user_suggestion.dart';

class CardSuggestion extends StatelessWidget {
  const CardSuggestion({Key? key}) : super(key: key);

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
                            "Suggestions",
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
      future: getSuggestions(),
    );
  }

  Future<Widget> getSuggestions() async {
    ApiFrancePartage api = ApiFrancePartage();
    List<Widget> usersList = [];

    usersList.add(const Padding(padding: EdgeInsets.only(left:2)));

    Map<String, dynamic> mapUserSuggestions = await api.getUserSuggestions();
    var jsonData = jsonDecode(mapUserSuggestions["body"])["data"];

    for(var data in jsonData) {
      usersList.add(
        Padding(
          padding: EdgeInsets.only(left:6, right:6),
          child: ProfileSuggestion(
            id: data["id"],
            displayName: data["displayName"],
            imgLink: AppUtils.getAvatarLink(data["avatar"])
          ),
        ),
      );
    }

    usersList.add(const Padding(padding: EdgeInsets.only(right:2)));

    return Row(
      children: usersList,
    );
  }
}
