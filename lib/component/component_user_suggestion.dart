import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import '../component/component_profile_picture.dart';

class ProfileSuggestion extends StatelessWidget {
  final String imgLink;
  final String firstname;
  final String lastname;
  final String mail;

  const ProfileSuggestion({Key? key, required this.imgLink, required this.firstname, required this.lastname, required this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfilePicture(
                link: imgLink,
                mail: mail,
                size: 28
              ),
              const SizedBox(
                height: 6,
              ),
              AppText(
                firstname,
              ),
              AppText(
                lastname,
              )
            ],
        ),
    );
  }
}
