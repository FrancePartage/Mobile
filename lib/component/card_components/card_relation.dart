import 'package:flutter/material.dart';
import 'package:france_partage/component/component_profile_picture.dart';
import 'package:france_partage/component/text_components/app_text.dart';

class CardRelation extends StatefulWidget {
  final String avatar;
  final String firstname;
  final String lastname;
  final String mail;
  final String relationType;
  const CardRelation({Key? key, required this.avatar, required this.firstname, required this.lastname, required this.mail, required this.relationType}) : super(key: key);

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
                          link: widget.avatar,
                          mail: widget.mail,
                          size: 34,
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              widget.firstname,
                              size: 22,
                            ),
                            AppText(
                              widget.lastname,
                              size: 22,
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: AppText(
                        widget.relationType,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );;
  }
}
