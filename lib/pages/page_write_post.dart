import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:france_partage/component/text_components/app_tag_selector.dart';
import 'package:image_picker/image_picker.dart';

import '../component/component_app_appbar.dart';
import '../component/component_app_drawer.dart';
import '../component/text_components/app_text.dart';
import '../component/text_components/app_textfield.dart';
import '../resources/app_colors.dart';
import '../resources/app_utils.dart';

class PageWritePost extends StatefulWidget {
  const PageWritePost({Key? key}) : super(key: key);

  @override
  State<PageWritePost> createState() => _PageWritePostState();
}

class _PageWritePostState extends State<PageWritePost> {
  bool sending = false;
  bool loaded = false;
  QuillController quillController = QuillController.basic();
  TextEditingController titleCtrl = TextEditingController();
  List<String> tagsList = [];
  ImagePicker picker = ImagePicker();
  XFile? cover = null;

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
        body: Center(
          child: Column(
            children: [
              ExpandablePanel(
                collapsed: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10, left: 10),
                        child: AppText("Ajouter une ressource", size: 34, color: AppColors.DARK_900,)
                    ),
                    AppTextField(labelText: "Titre", hintText: "", textController: titleCtrl, sizeRatio: 0.9),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTagSelector(tagsList: tagsList, callbackRemoveTag: removeTag),
                          ElevatedButton(
                            onPressed: addTag,
                            child: AppText("Ajouter un Tag"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.DARK_500),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: AppText((cover != null ? cover!.name : "")),
                              )
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          ElevatedButton(
                            onPressed: pickCover,
                            child: AppText("Choisir une couverture"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.DARK_500),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    ExpandableButton(
                      child: Center(child: const Icon(Icons.keyboard_arrow_up_rounded)),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10))
                  ],
                ),
                expanded: ExpandableButton(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Center(child: const Icon(Icons.keyboard_arrow_down_rounded)),
                ),
              ),
              ),
              QuillToolbar.basic(controller: quillController, multiRowsDisplay: false),
              Expanded(
                child: Container(
                  color: AppColors.WHITE,
                  child: QuillEditor.basic(
                    controller: quillController,
                    readOnly: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: sendResource,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.BLUE, AppColors.CYAN ])
              ),
              child: const Icon(Icons.check),
            )
        ),
      );
    }
  }

  void addTag() {
    TextEditingController commentCtrl = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: AppText('Ajouter un tag', size: 20),
        content: AppTextField(labelText: "Tag", hintText: "", textController: commentCtrl),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Annuler');
            },
            child: const AppText(
              "Annuler",
              size: 20,
              color: AppColors.DARK_800,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Valider');
              tagsList.add(commentCtrl.text);
              setState(() {});
            },
            child: const AppText(
              "Valider",
              size: 20,
              color: AppColors.BLUE,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickCover() async {
    cover = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void displayError(error) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: AppText("Erreur :", size: 20, color: AppColors.RED_600,),
        content: AppText(error, size: 16, color: AppColors.RED_600,),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const AppText(
              "OK",
              size: 20,
              color: AppColors.BLUE,
            ),
          ),
        ],
      ),
    );
  }

  void sendResource() {
    if(sending) {
      //return;
    }

    if(titleCtrl.text == "") {
      displayError("Titre vide");
      return;
    }

    if(tagsList.length == 0) {
      displayError("Aucun tag");
      return;
    }

    if(!(cover != null)) {
      displayError("Aucune cover");
      return;
    }

    sending = true;

    print(titleCtrl.text);
    print(tagsList);
    print(cover!.name);
    print(quillController.document.toDelta());
  }

  void removeTag(String tag) {
    tagsList.remove(tag);
    setState(() {});
  }
}
