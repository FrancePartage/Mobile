import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/component/text_components/app_textfield.dart';
import 'package:france_partage/models/app_global.dart';
import 'package:france_partage/pages/page_home.dart';
import 'package:france_partage/pages/page_register.dart';
import 'package:france_partage/resources/app_colors.dart';
import '../resources/app_utils.dart';


class PageLogIn extends StatefulWidget {
  const PageLogIn({Key? key}) : super(key: key);

  @override
  _PageLogInState createState() => _PageLogInState();
}

class _PageLogInState extends State<PageLogIn> {

  TextEditingController mailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  String errorMsg = "";
  late String text;
  @override
  Widget build(BuildContext context) {
    checkLogin();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              heightFactor: 3.5,
              child: Card(
                  elevation: 5.0,
                  child: Container(
                    width: 84,
                    height: 84,
                    child: Image.asset(
                      "Assets/img/Logo.png",
                      fit: BoxFit.cover,
                    ),
                  )
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child:Text("Connexion",
                style: TextStyle(
                  color: AppColors.DARK_900,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppText(
              errorMsg,
              color: Colors.red,
              size: 16,
            ),
            AppTextField(
              labelText: "E-mail",
              hintText: "example@mail.fr",
              textController: mailCtrl
            ),
            AppTextField(
              labelText: "Mot de passe",
              hintText: "******",
              textController: passwordCtrl,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 44.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                  child: const Text("Se connecter",
                    style: TextStyle(
                      color: AppColors.WHITE,
                    ),
                  ),
                  onPressed: (){
                    login();
                  },
                ),
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context)
                    {
                      return const PageRegister();
                    }
                  )
                );
              },
              child: const Text("Créer un compte",
                style: TextStyle(
                  color: AppColors.BLUE,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              )
            ),
          ],
        ),
      )
    );
  }

  void login() async {
    ApiFrancePartage api = ApiFrancePartage();
    String mail = mailCtrl.text.trim();
    String password = passwordCtrl.text;

    Map<String, dynamic> mapLogin = await api.login(mail: mail, password: password);

    if(mapLogin["code"] == 200) {
      setState(() {
        errorMsg = "";
      });

      final storage = new FlutterSecureStorage();
      await storage.write(key: "accessToken", value: jsonDecode(mapLogin["body"])["accessToken"]);
      await storage.write(key: "refreshToken", value: jsonDecode(mapLogin["body"])["refreshToken"]);

      await AppUtils.getUserInfos();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return PageHome();
        })
      );
    } else {
      String error = jsonDecode(mapLogin["body"])["message"];
      setState(() {
        errorMsg = error;
      });
    }
  }

  void checkLogin() async {
    /*
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    if(token != null) {
      await AppUtils.getUserInfos();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return PageHome();
        })
      );
    }
    */
  }
}
