import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../api/api_france_partage.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_utils.dart';
import '../component_profile_picture.dart';
import '../text_components/app_tag.dart';
import '../text_components/app_text.dart';

class CardCompletePost extends StatefulWidget {
  final int id;
  final String title;
  final DateTime createdAt;
  final List<String> tags;
  bool favorite;
  String content;

  final int authorId;
  final String authorDisplayName;
  final String authorAvatar;

  CardCompletePost({Key? key, required this.id, required this.title, required this.createdAt, required this.tags, required this.favorite, required this.authorId, required this.authorDisplayName, required this.authorAvatar, required this.content}) : super(key: key) {}

  @override
  State<CardCompletePost> createState() => _CardCompletePostState();
}

class _CardCompletePostState extends State<CardCompletePost> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // For tests, not usefull for prod version
    widget.content = widget.content.replaceAll("localhost:3333", AppUtils.IP);
    // End of tests

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
                        Expanded(child: Container(),),
                        InkWell(
                          child: getFavoriteIcon(),
                          onTap: () {
                            changeLike();
                            setState(() {
                              widget.favorite = !widget.favorite;
                            });
                          },
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.title,
                          size: 22,
                          color: AppColors.BLUE,
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: getTags()
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 12),
                          child: Container(
                            color: AppColors.DARK_600,
                            height: 1,
                          ),
                        ),
                        Html(data: widget.content)
                      ],
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  Icon getFavoriteIcon() {
    if(widget.favorite) {
      return Icon(
        Icons.favorite,
        color: AppColors.BLUE,
        size: 36,
      );
    } else {
      return Icon(
        Icons.favorite_border,
        color: AppColors.DARK_800,
        size: 36,
      );
    }
  }

  Widget getTags() {
    List<Widget> tagsList = [];

    widget.tags.forEach((tag) {
      tagsList.add(AppTag(tag: tag));
      tagsList.add(SizedBox(width: 8));
    });

    return Row(
      children: tagsList,
    );
  }

  changeLike() async {
    ApiFrancePartage api = ApiFrancePartage();
    await api.changeLike(widget.id, widget.favorite);
  }
}
