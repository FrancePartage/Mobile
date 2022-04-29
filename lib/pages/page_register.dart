import 'dart:convert';

import 'package:flutter/material.dart';
import '../api/api_france_partage.dart';
import '../component/text_components/app_text.dart';
import '../pages/page_log_in.dart';
import '../ressources/app_colors.dart';
import '../component/text_components/app_textfield.dart';

class PageRegister extends StatefulWidget {
  const PageRegister({Key? key}) : super(key: key);

  @override
  _PageRegisterState createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {

  TextEditingController mailCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  //TextEditingController birthdateCtrl = TextEditingController();
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
              child:Text("Sign-up",
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
            AppTextField(labelText: "Nom", hintText: "Roger", textController: lastnameCtrl),
            AppTextField(labelText: "Prénom", hintText: "Rémi", textController: firstnameCtrl,),
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
                      register();
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

  void register() async {
    ApiFrancePartage api = ApiFrancePartage();
    errorMsg = "";

    String mail = mailCtrl.text.trim();
    String firstname = firstnameCtrl.text;
    String lastname = lastnameCtrl.text;
    String password = passwordCtrl.text;
    String passwordConfirm = passwordConfirmCtrl.text;

    if( !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail) ) {
      setState(() {
        errorMsg = "E-Mail Invalide";
      });
    } else if ( password != passwordConfirm ) {
      setState(() {
        errorMsg = "Passwords not the same";
      });
    } else {
      Map<String, dynamic> mapRegister = await api.register(mail: mail, password: password, firstname: firstname, lastname: lastname);

      bool success = jsonDecode(mapRegister["body"])["success"];
      if(success) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context){
            return PageLogIn();
          })
        );
      } else {
        String error = jsonDecode(mapRegister["body"])["message"];
        setState(() {
          errorMsg = error;
        });
      }
    }
  }
}
