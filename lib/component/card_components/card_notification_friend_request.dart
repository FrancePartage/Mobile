import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/ressources/app_colors.dart';

import '../component_profile_picture.dart';
import '../text_components/app_text.dart';

class CardNotificationFriendRequest extends StatelessWidget {
  final String imgLink;
  final String firstname;
  final String lastname;
  final String mail;
  final String relationType;
  final String relationId;
  final Function callbackReload;

  const CardNotificationFriendRequest({Key? key, required this.imgLink, required this.firstname, required this.lastname, required this.mail, required this.relationType, required this.relationId, required this.callbackReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double btnSizeConstraint = 46;
    BoxConstraints boxConstraints = BoxConstraints(
        minWidth: btnSizeConstraint,
        maxWidth: btnSizeConstraint,
        minHeight: btnSizeConstraint,
        maxHeight: btnSizeConstraint
    );

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Center(
          child: Card(
            elevation: 4,
            child: Container(
                width: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ProfilePicture(
                            link: imgLink,
                            mail: mail,
                            size: 28,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                firstname,
                                size: 16,
                              ),
                              AppText(
                                lastname,
                                size: 16,
                              ),
                              AppText(
                                "( " + relationType + " )",
                                size: 12,
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          RawMaterialButton(
                            constraints: boxConstraints,
                            onPressed: () {
                              denyRequest();
                            },
                            elevation: 2.0,
                            fillColor: AppColors.DARK_500,
                            child: const Icon(
                              Icons.clear,
                              size: 28,
                              color: AppColors.BLUE,
                            ),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          RawMaterialButton(
                            constraints: boxConstraints,
                            onPressed: () {
                              acceptRequest();
                            },
                            elevation: 2.0,
                            fillColor: AppColors.BLUE,
                            child: const Icon(
                              Icons.check,
                              size: 28,
                              color: Colors.white,
                            ),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            ),
          )
      ),
    );
  }

  Future<void> acceptRequest() async {
    ApiFrancePartage api = ApiFrancePartage();
    Map<String, dynamic> mapDeny = await api.acceptFriendRequest(relationId);

    if(jsonDecode(mapDeny["body"])["success"]) {
      callbackReload();
    } else {
      print("Error when denying request");
    }
  }

  Future<void> denyRequest() async {
    ApiFrancePartage api = ApiFrancePartage();
    Map<String, dynamic> mapDeny = await api.denyFriendRequest(relationId);

    if(jsonDecode(mapDeny["body"])["success"]) {
      callbackReload();
    } else {
      print("Error when denying request");
    }
  }
}