import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/resources/app_colors.dart';
import 'package:france_partage/resources/app_utils.dart';
import '../../component/component_profile_picture.dart';
import '../text_components/app_tag.dart';
import '../text_components/app_text.dart';


class CardPost extends StatefulWidget {
  final int id;
  final String title;
  final DateTime createdAt;
  final String cover;
  final List<String> tags;
  bool favorite;

  final int authorId;
  final String authorDisplayName;
  final String authorAvatar;

  CardPost({Key? key, required this.id, required this.title, required this.createdAt, required this.cover, required this.tags, required this.favorite, required this.authorId, required this.authorDisplayName, required this.authorAvatar}) : super(key: key) {}

  @override
  _CardPostState createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
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
                  InkWell(
                    child: Column(
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
                        SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(widget.cover),
                            height: 200,
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      goToPostPage();
                    },
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  void goToPostPage() {
    print("Going to post page");
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