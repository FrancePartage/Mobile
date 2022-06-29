import 'package:flutter/material.dart';
import 'package:france_partage/component/component_profile_picture.dart';
import 'package:france_partage/component/text_components/app_text.dart';

import '../../resources/app_utils.dart';

class CardRelation extends StatefulWidget {
  final int id;
  final String avatar;
  final String displayName;
  final String? type;
  const CardRelation({Key? key, required this.id, required this.avatar, required this.displayName, this.type = null}) : super(key: key);

  @override
  State<CardRelation> createState() => _CardRelationState();
}

class _CardRelationState extends State<CardRelation> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Center(
        child: Card(
            elevation: 4,
            child: Container(
              width: size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfilePicture(
                          link: AppUtils.getAvatarLink(widget.avatar),
                          id: widget.id,
                          size: 34,
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              widget.displayName,
                              size: 22,
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: AppText(
                        (widget.type != null ? AppUtils.getRequestTypeName(widget.type!) : ""),
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
