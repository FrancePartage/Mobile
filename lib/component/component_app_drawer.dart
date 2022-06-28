import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/pages/page_settings.dart';
import 'package:france_partage/resources/app_colors.dart';
import '../pages/page_log_in.dart';
import '../pages/page_notification.dart';
import '../pages/page_user_profile.dart';
import 'text_components/app_text_drawer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: AppColors.DARK_DRAWER,
      child: Padding(
        padding: EdgeInsets.only(top: size.height / 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:[
                TextButton(
                    onPressed: () {
                      goToProfile(context);
                    },
                    child: const AppTextDrawer(text: "Profil")
                )
              ]
            ),
            Row(
                children:[
                  TextButton(
                      onPressed: () {
                        goToNotification(context);
                      },
                      child: const AppTextDrawer(text: "Notifications")
                  )
                ]
            ),
            Row(
                children:[
                  TextButton(
                      onPressed: () {
                        goToParameter(context);
                      },
                      child : const AppTextDrawer(text: "Paramètres")
                  )
                ]
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      returnToLogIn(context);
                    },
                    child : const AppTextDrawer(text: "Déconnexion")
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    returnToLogIn(context);
                  },
                  icon: const Icon(
                    Icons.exit_to_app
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void goToProfile(context) {
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context){
        return PageUserProfile(
          id: AppGlobal.userInfos!.id!,
        );
      })
    );
  }

  void goToNotification(context) {
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context){
        return const PageNotification();
      })
    );
  }

  void goToParameter(context) {
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context){
        return const PageSettings();
      })
    );
  }

  void returnToLogIn(context) async {
    final storage = new FlutterSecureStorage();
    ApiFrancePartage api = new ApiFrancePartage();
    await api.logout();
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken");
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context){
        return const PageLogIn();
      })
    );
  }
}
