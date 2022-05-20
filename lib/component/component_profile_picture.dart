import 'package:flutter/material.dart';

import '../pages/page_user_profile.dart';

class ProfilePicture extends StatelessWidget {
  final String link;
  final int id;
  final double? size;
  final bool? redirect;
  const ProfilePicture({Key? key, required this.id, required this.link, this.size = 26, this.redirect = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(this.redirect!) {
      return InkWell(
        child: CircleAvatar(
          radius: size!,
          backgroundImage: NetworkImage(link),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context){
              return PageUserProfile(
                id: id,
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
