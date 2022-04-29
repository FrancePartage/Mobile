import 'package:flutter/material.dart';
import '../component/component_profile_picture.dart';
import '../pages/page_home.dart';
import '../ressources/app_colors.dart';

class AppAppbar extends StatefulWidget implements PreferredSizeWidget{
  final String avatar;
  const AppAppbar({Key? key, required this.avatar}) : super(key: key);

  @override
  _AppAppbarState createState() => _AppAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(58.0);
}

class _AppAppbarState extends State<AppAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.DARK_800,
      leading: IconButton(
        onPressed: () {
          returnToHome(context);
        },
        icon: Image.asset(
          "Assets/img/Logo.png",
          fit: BoxFit.cover,
        ),
      ),
      title: Container(
          height: 44.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.DARK_900,
          ),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: const OutlineInputBorder(),
              hintText: "Rechercher",
              hintStyle: const TextStyle(color: AppColors.DARK_600),
              suffixIcon: const Icon(
                Icons.zoom_in_sharp,
                color: AppColors.DARK_600,
              )
            ),
          )
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: ProfilePicture(
                link: widget.avatar,
                mail: "/",
                size: 16,
              )
          ),
        ),
      ],
    );
  }

  void returnToHome(context) {
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
        return const PageHome();
      })
    );
  }
}


