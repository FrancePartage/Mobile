import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import '../component/component_profile_picture.dart';

class ProfileSuggestion extends StatelessWidget {
  final int id;
  final String imgLink;
  final String displayName;

  const ProfileSuggestion({Key? key, required this.imgLink, required this.displayName, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ProfilePicture(
            link: imgLink,
            id: id,
            size: 28
          ),
          const SizedBox(
            height: 6,
          ),
          AppText(
            displayName,
          )
        ],
      ),
    );
  }
}
