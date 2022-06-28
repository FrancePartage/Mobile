import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/models/app_global.dart';

import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';
import '../component/text_components/app_textfield.dart';
import '../resources/app_colors.dart';
import '../resources/app_utils.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  bool loaded = false;
  String errorMsgInfos = "";
  String errorMsgPassword = "";

  TextEditingController mailCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passwordConfirmCtrl = TextEditingController();

  @override
  void initState() {
    loaded = false;
    AppUtils.getUserInfos().then((value) => setState(() {
      loaded = true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    if(!loaded) {
      return Container();
    } else {
      return Scaffold(
          appBar: AppAppbar(),
          endDrawer: AppDrawer(),
          body: getWidget()
      );
    }
  }

  Widget getWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("LOADING"),);
        } else {
          if(projectSnap.hasData) {
            return projectSnap.data as Widget;
          } else {
            return const Center(child: Text("ERROR"),);
          }
        }
      },
      future: getUserInfosFuture(),
    );
  }

  Future<Widget> getUserInfosFuture() async {
    ApiFrancePartage api = ApiFrancePartage();

    Map<String, dynamic> mapUserInfos = await api.getMyInfos();
    var jsonData = jsonDecode(mapUserInfos["body"]);

    usernameCtrl.text = jsonData["username"];
    lastnameCtrl.text = jsonData["lastname"];
    firstnameCtrl.text = jsonData["firstname"];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Modifier les informations",
              style: TextStyle(
                color: AppColors.DARK_900,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppText(
              errorMsgInfos,
              color: Colors.red,
              size: 16,
            ),
            AppText(jsonData["email"], size: 20, color: AppColors.DARK_700),
            AppTextField(labelText: "Nom d'utilisateur", hintText: "Pseudonyme", textController: usernameCtrl,),
            AppTextField(labelText: "Prénom", hintText: "John", textController: firstnameCtrl,),
            AppTextField(labelText: "Nom", hintText: "Doe", textController: lastnameCtrl),
            Padding(padding: EdgeInsets.only(top: 8)),
            ElevatedButton(
              onPressed: () {
                saveUserInfosChanges();
              },
              child: AppText(
                "Sauvegarder",
                color: AppColors.DARK_500,
                size: 20,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.BLUE),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    )
                )
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text("Modifier le mot de passe",
              style: TextStyle(
                color: AppColors.DARK_900,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppText(
              errorMsgPassword,
              color: Colors.red,
              size: 16,
            ),
            AppTextField(labelText: "Ancien mot de passe", hintText: "******", textController: oldPasswordCtrl, obscureText: true,),
            AppTextField(labelText: "Nouveau mot de passe", hintText: "******", textController: passwordCtrl, obscureText: true,),
            AppTextField(labelText: "Confirmation du nouveau mot de passe", hintText: "******", textController: passwordConfirmCtrl, obscureText: true,),
            Padding(padding: EdgeInsets.only(top: 8)),
            ElevatedButton(
              onPressed: () {
                changePassword();
              },
              child: AppText(
                "Changer",
                color: AppColors.DARK_500,
                size: 20,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.BLUE),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      )
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveUserInfosChanges() async {
    String username = usernameCtrl.text;
    String firstname = firstnameCtrl.text;
    String lastname = lastnameCtrl.text;

    ApiFrancePartage api = ApiFrancePartage();
    Map<String, dynamic> mapResult = await api.updateUserInfos(username, firstname, lastname);

    if(mapResult["code"] == 200) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Informations changées'),
          actions: <Widget>[
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Ok');
                  },
                  child: const AppText(
                    "OK",
                    size: 20,
                    color: AppColors.BLUE,
                  ),
                ),
              ],
            )
          ],
        )
      );
    }
  }

  void changePassword() async {
    String oldPassword = oldPasswordCtrl.text;
    String password = passwordCtrl.text;
    String passwordConfirm = passwordConfirmCtrl.text;

    if(password == "" || passwordConfirm == "" || oldPassword == "") {
      setState(() {
        errorMsgPassword = "Le mot de passe ne peut pas être vide";
      });
    }

    if(password != passwordConfirm) {
      setState(() {
        errorMsgPassword = "Le mot de passe ne correspond pas à la confirmation";
      });
    }

    ApiFrancePartage api = ApiFrancePartage();
    Map<String, dynamic> mapResult = await api.updateUserPassword(oldPassword, password);

    if(mapResult["code"] == 200) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Mot de passe changé'),
            actions: <Widget>[
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Ok');
                    },
                    child: const AppText(
                      "OK",
                      size: 20,
                      color: AppColors.BLUE,
                    ),
                  ),
                ],
              )
            ],
          )
      );
      setState(() {
        errorMsgPassword = "";
      });
    } else {
      String error = jsonDecode(mapResult["body"])["message"];
      setState(() {
        errorMsgPassword = error;
      });
    }
  }
}
