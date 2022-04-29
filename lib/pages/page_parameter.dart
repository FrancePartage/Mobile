import 'package:flutter/material.dart';
import '../component/text_components/app_textfield.dart';

import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';
import '../models/app_global.dart';
import '../ressources/app_colors.dart';
import '../ressources/app_utils.dart';

class PageParameter extends StatefulWidget {
  const PageParameter({Key? key}) : super(key: key);

  @override
  _PageParameterState createState() => _PageParameterState();
}

class _PageParameterState extends State<PageParameter> {

  @override
  void initState() {
    AppUtils.getUserInfos().then((value) => setState(() {}));
  }

  TextEditingController mailCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController forenameCtrl = TextEditingController();
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(
        avatar: AppUtils.getImageLink(AppGlobal.userInfos!.avatar!),
      ),
      endDrawer: AppDrawer(
        mail: AppGlobal.userInfos!.email!,
      ),
      body: SingleChildScrollView (
        child: Center(
          child : Column (
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              AppText("Edit Profil", size: 28),
              Padding(padding: EdgeInsets.only(top: 20)),
              ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder()
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage("https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png"))
                    ),
                    child: const Icon(Icons.add),
                  )),
              Padding(padding: EdgeInsets.only(top: 20)),
              AppTextField(labelText: "E-mail", hintText: "test@hotmail.fr", textController: mailCtrl),
              AppTextField(labelText: "Nom", hintText: "Roger", textController: nameCtrl),
              AppTextField(labelText: "Prénom", hintText: "Rémi", textController: forenameCtrl,),
              Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                height: 38.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const ElevatedButton(
                  onPressed: null,
                  child: AppText("Sauvegarder", color: AppColors.WHITE),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              AppText("Change Password", size: 28),
              Padding(padding: EdgeInsets.only(top: 20)),
              AppTextField(labelText: "Ancien mot de passe", hintText: "", textController: oldPasswordCtrl),
              AppTextField(labelText: "Nouveau mot de passe", hintText: "", textController: newPasswordCtrl,),
              AppTextField(labelText: "Confirmation mot de passe", hintText: "", textController: confirmPasswordCtrl,),
              Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                height: 38.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const ElevatedButton(
                  onPressed: null,
                  child: AppText("Modifier", color: AppColors.WHITE),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 60)),
            ],
          ),
        )
      )
    );
  }
}
