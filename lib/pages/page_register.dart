import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:france_partage/pages/page_home.dart';
import '../api/api_france_partage.dart';
import '../component/text_components/app_text.dart';
import '../pages/page_log_in.dart';
import '../resources/app_colors.dart';
import '../component/text_components/app_textfield.dart';
import '../resources/app_utils.dart';

class PageRegister extends StatefulWidget {
  const PageRegister({Key? key}) : super(key: key);

  @override
  _PageRegisterState createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {

  TextEditingController mailCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passwordConfirmCtrl = TextEditingController();

  String errorMsg = "";
  late String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              heightFactor: 2.80,
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
              child:Text("Inscription",
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
            AppTextField(labelText: "E-mail", hintText: "test@test.fr", textController: mailCtrl),
            AppTextField(labelText: "Nom d'utilisateur", hintText: "Pseudonyme", textController: usernameCtrl,),
            AppTextField(labelText: "Prénom", hintText: "John", textController: firstnameCtrl,),
            AppTextField(labelText: "Nom", hintText: "Doe", textController: lastnameCtrl),
            AppTextField(labelText: "Mot de passe", hintText: "******", textController: passwordCtrl, obscureText: true,),
            AppTextField(labelText: "Confirmation mot de passe", hintText: "******", textController: passwordConfirmCtrl, obscureText: true,),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      registerCheck();
                    },
                    child: const Text("Valider",
                      style: TextStyle(
                        color: AppColors.WHITE,
                      ),
                    ),
                  ),
                )
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context){
                      return const PageLogIn();
                    })
                  );
                },
                child: const Text("Se connecter",
                  style: TextStyle(
                    color: AppColors.BLUE,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                )
            )
          ],
        ),
      )

    );
  }

  void registerCheck() async {
    errorMsg = "";

    String mail = mailCtrl.text.trim();
    String password = passwordCtrl.text;
    String passwordConfirm = passwordConfirmCtrl.text;

    if(!checkEmpty(mail, "mail") || !checkEmpty(usernameCtrl.text, "pseudonyme") || !checkEmpty(firstnameCtrl.text, "prénom") || !checkEmpty(lastnameCtrl.text, "nom") || !checkEmpty(password, "mot de passe")) {
      return;
    }

    if( !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail) ) {
      setState(() {
        errorMsg = "E-Mail Invalide";
      });
    } else if ( password != passwordConfirm ) {
      setState(() {
        errorMsg = "Les mots de passe ne correspondent pas";
      });
    } else {
      setState(() {
        errorMsg = "";
      });

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confidentialité'),
          content: const Text("J'accepte d'afficher mon nom et prénom en public"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Refuser');
                registerUser(false);
              },
              child: const AppText(
                "Refuser",
                size: 20,
                color: AppColors.DARK_800,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Accepter');
                registerUser(true);
              },
              child: const AppText(
                "Accepter",
                size: 20,
                color: AppColors.BLUE,
              ),
            ),
          ],
        ),
      );
    }
  }

  void registerUser(bool rgpd) async {
    ApiFrancePartage api = ApiFrancePartage();

    String mail = mailCtrl.text.trim();
    String username = usernameCtrl.text;
    String firstname = firstnameCtrl.text;
    String lastname = lastnameCtrl.text;
    String password = passwordCtrl.text;

    Map<String, dynamic> mapRegister = await api.register(mail: mail, password: password, username: username, firstname: firstname, lastname: lastname, acceptRgpd: rgpd);

    if(mapRegister["code"] == 201) {
      setState(() {
        errorMsg = "";
      });

      final storage = new FlutterSecureStorage();
      await storage.write(key: "accessToken", value: jsonDecode(mapRegister["body"])["accessToken"]);
      await storage.write(key: "refreshToken", value: jsonDecode(mapRegister["body"])["refreshToken"]);

      await AppUtils.getUserInfos();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return PageHome();
        })
      );
    } else {
      errorMsg = "";
      setState(() {
        if(jsonDecode(mapRegister["body"])["message"] is List<dynamic>) {
          jsonDecode(mapRegister["body"])["message"].forEach((element) => {
            errorMsg += "\n" + element
          });
        } else {
          errorMsg = jsonDecode(mapRegister["body"])["message"];
        }
      });
    }
  }

  bool checkEmpty(String content, String field) {
    if(content.isEmpty) {
      setState(() {
        errorMsg = "Votre " + field + " ne doit pas être vide";
      });
      return false;
    }
    return true;
  }
}
