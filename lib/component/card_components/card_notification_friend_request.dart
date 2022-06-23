import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/resources/app_utils.dart';

import '../../api/api_france_partage.dart';
import '../../resources/app_colors.dart';
import '../component_profile_picture.dart';
import '../text_components/app_text.dart';

class CardNotificationFriendRequest extends StatelessWidget {
  final int id;
  final String avatar;
  final String displayName;
  final String type;
  final int requestId;
  final Function callbackReload;

  const CardNotificationFriendRequest({Key? key, required this.id, required this.avatar, required this.displayName, required this.type, required this.requestId, required this.callbackReload}) : super(key: key);

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
                            link: AppUtils.getAvatarLink(avatar),
                            id: id,
                            size: 28,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                displayName,
                                size: 16,
                              ),
                              AppText(
                                "( " + AppUtils.getRequestTypeName(type) + " )",
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
    Map<String, dynamic> mapAccept = await api.acceptRequest(requestId);

    if(mapAccept["code"] == 200) {
      callbackReload();
    } else {
      print("Error when accepting request");
    }
  }

  Future<void> denyRequest() async {
    ApiFrancePartage api = ApiFrancePartage();
    Map<String, dynamic> mapDeny = await api.denyRequest(requestId);


    if(mapDeny["code"] == 200) {
      callbackReload();
    } else {
      print("Error when denying request");
    }
  }
}