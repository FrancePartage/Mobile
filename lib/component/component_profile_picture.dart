import 'package:flutter/material.dart';

import '../pages/page_user_profile.dart';

class ProfilePicture extends StatelessWidget {
  final String link;
  final String mail;
  final double? size;
  const ProfilePicture({Key? key, required this.link, this.size = 26, required this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(mail != "/") {
      return InkWell(
        child: CircleAvatar(
          radius: size!,
          backgroundImage: NetworkImage(link),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context){
                return PageUserProfile(
                  mail: mail,
                );
              })
          );
        },
      );
    } else {
      return CircleAvatar(
        radius: size!,
        backgroundImage: NetworkImage(link),
      );
    }
  }
}
