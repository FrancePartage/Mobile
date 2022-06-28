import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:france_partage/api/api_france_partage.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/resources/app_utils.dart';

import '../resources/app_colors.dart';

class RelationButton extends StatefulWidget {
  final int id;
  final int requestId;
  final String type;
  final Function callbackReload;

  const RelationButton({Key? key, required this.id, required this.type, required this.callbackReload, required this.requestId}) : super(key: key);

  @override
  State<RelationButton> createState() => _RelationButtonState();
}

class _RelationButtonState extends State<RelationButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if(widget.type == "ADD") {
          sendRequest();
        }
        if(widget.type == "PENDING") {
          cancelRequest();
        }
        if(widget.type == "REMOVE") {
          removeRelation();
        }
      },
      child: Icon(
        getIcon(),
        size: 28,
        color: getIconColor(),
      ),
      style: ButtonStyle(

        backgroundColor: MaterialStateProperty.all<Color>(getBackgroundColor()),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
        )
      ),
    );
  }

  IconData getIcon() {
    if(widget.type == "ADD") {
      return Icons.person_add_alt_1;
    }
    return Icons.person_remove_alt_1;
  }

  Color getIconColor() {
    if(widget.type == "ADD") {
      return AppColors.BLUE;
    }
    if(widget.type == "PENDING") {
      return AppColors.ORANGE_600;
    }
    return AppColors.RED_600;
  }

  Color getBackgroundColor() {
    if(widget.type == "ADD") {
      return AppColors.DARK_500;
    }
    if(widget.type == "PENDING") {
      return AppColors.ORANGE_200;
    }
    return AppColors.RED_200;
  }

  void sendRequest() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Demande d\'ajout'),
        content: const Text("Selectionnez un type :"),
        actions: <Widget>[
          Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Ami');
                  sendRequestType("Ami");
                },
                child: const AppText(
                  "Ami",
                  size: 20,
                  color: AppColors.BLUE,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Conjoint');
                  sendRequestType("Conjoint");
                },
                child: const AppText(
                  "Conjoint",
                  size: 20,
                  color: AppColors.BLUE,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Collègue');
                  sendRequestType("Collègue");
                },
                child: const AppText(
                  "Collègue",
                  size: 20,
                  color: AppColors.BLUE,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Famille');
                  sendRequestType("Famille");
                },
                child: const AppText(
                  "Famille",
                  size: 20,
                  color: AppColors.BLUE,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  sendRequestType(String typeName) async {
    String type = AppUtils.getRequestTypeName(typeName);

    ApiFrancePartage api = ApiFrancePartage();
    await api.sendRelation(widget.id, type);
    widget.callbackReload();
  }

  cancelRequest() async {
    ApiFrancePartage api = ApiFrancePartage();
    await api.cancelRelation(widget.requestId);
    widget.callbackReload();
  }

  removeRelation() async {
    ApiFrancePartage api = ApiFrancePartage();
    await api.removeRelation(widget.requestId);
    widget.callbackReload();
  }
}
