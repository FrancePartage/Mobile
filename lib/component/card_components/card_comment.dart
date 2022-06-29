import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_utils.dart';
import '../component_profile_picture.dart';
import '../text_components/app_text.dart';

class CardComment extends StatefulWidget {

  final int authorId;
  final String authorDisplayName;
  final String authorAvatar;
  final DateTime createdAt;
  final String content;
  
  const CardComment({Key? key, required this.authorId, required this.authorDisplayName, required this.authorAvatar, required this.createdAt, required this.content}) : super(key: key);
  
  @override
  State<CardComment> createState() => _CardCommentState();
}

class _CardCommentState extends State<CardComment> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Center(
        child: Card(
            elevation: 4,
            child: Container(
              width: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfilePicture(
                          link: widget.authorAvatar,
                          id: widget.authorId,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              widget.authorDisplayName,
                              size: 18,
                            ),
                            AppText(
                              AppUtils.getDateDifference(widget.createdAt),
                              size: 12,
                              color: AppColors.BLUE,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 6,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 12),
                      child: Container(
                        color: AppColors.DARK_600,
                        height: 1,
                      ),
                    ),
                    //Content Display
                    AppText(widget.content, size: 14,)
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
