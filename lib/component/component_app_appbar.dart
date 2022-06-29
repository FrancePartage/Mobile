import 'package:flutter/material.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/pages/page_search.dart';
import 'package:france_partage/resources/app_utils.dart';
import '../pages/page_home.dart';
import '../resources/app_colors.dart';
import 'component_profile_picture.dart';

class AppAppbar extends StatefulWidget implements PreferredSizeWidget{
  const AppAppbar({Key? key}) : super(key: key);

  @override
  _AppAppbarState createState() => _AppAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(58.0);
}

class _AppAppbarState extends State<AppAppbar> {
  TextEditingController searchCtrl = TextEditingController();

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
            style: TextStyle(color: AppColors.WHITE),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: const OutlineInputBorder(),
              hintText: "Rechercher",
              hintStyle: const TextStyle(color: AppColors.DARK_600),
              suffixIcon: InkWell(
                onTap: () {
                  goToSearchPage(context);
                },
                child: const Icon(
                  Icons.zoom_in_sharp,
                  color: AppColors.DARK_600,
                ),
              )
            ),
            controller: searchCtrl,
          )
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: ProfilePicture(
              link: AppUtils.getAvatarLink(AppGlobal.userInfos!.avatar!),
              id: AppGlobal.userInfos!.id!,
              redirect: false,
              size: 16,
            )
          ),
        ),
      ],
    );
  }

  void returnToHome(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context){
        return PageHome();
      })
    );
  }

  void goToSearchPage(context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return PageSearch(search: searchCtrl.text);
        })
    );
  }
}


