import 'package:flutter/material.dart';
import 'package:france_partage/ressources/app_colors.dart';
import '../../component/component_profile_picture.dart';
import '../text_components/app_text.dart';


class CardPost extends StatefulWidget {
  final String avatar;
  final String firstname;
  final String lastname;
  final String mail;
  final String content;
  final int nbComments;
  final bool like;
  CardPost({Key? key, required this.avatar, required this.firstname, required this.lastname, required this.content, required this.nbComments, required this.like, required this.mail}) : super(key: key) {}

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
                        link: widget.avatar,
                        mail: widget.mail,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AppText(
                        widget.firstname,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      AppText(
                        widget.lastname,
                        size: 20,
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
                  AppText(
                    widget.content,
                    size: 16,
                  ),
                  SizedBox(
                    height: 6,
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );

    /*
      To use for favorites / comments

      Icon(Icons.favorite_border)
      Icon(Icons.chat_bubble_outline)
     */
  }
}