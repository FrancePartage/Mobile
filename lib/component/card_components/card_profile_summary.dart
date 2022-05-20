import 'package:flutter/material.dart';
import '../../component/component_profile_picture.dart';
import '../../component/text_components/app_text.dart';
import '../../resources/app_colors.dart';

class CardProfileSummary extends StatefulWidget {
  final int id;
  final String username;
  final String avatar;
  final int nbRessources;
  final int nbRelations;
  final String selectedTab;
  final Function(String) callback;
  const CardProfileSummary({Key? key,required this.id, required this.username, required this.nbRessources, required this.nbRelations, required this.callback, required this.selectedTab, required this.avatar}) : super(key: key);

  @override
  _CardProfileSummaryState createState() => _CardProfileSummaryState();
}

class _CardProfileSummaryState extends State<CardProfileSummary> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Center(
        child: Card(
          elevation: 4,
          child: Container(
            width: size.width * 0.9,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfilePicture(
                    link: widget.avatar,
                    id: widget.id,
                    redirect: false,
                    size: 70
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: AppText(widget.username, size: 28, textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Center(
                            child: Column(
                              children: [
                                AppText(widget.nbRessources.toString(), size: 32),
                                const AppText("Ressources", size: 20, color: AppColors.DARK_600),
                                getSelectionIndicator(widget.selectedTab == "resources")
                              ],
                            ),
                          ),
                          onTap: () {
                            widget.callback("resources");
                          },
                        ),
                        InkWell(
                          child: Center(
                            child: Column(
                              children: [
                                AppText(widget.nbRelations.toString(), size: 32),
                                const AppText("Relations", size: 20, color: AppColors.DARK_600),
                                getSelectionIndicator(widget.selectedTab == "relations")
                              ],
                            ),
                          ),
                          onTap: () {
                            widget.callback("relations");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSelectionIndicator(bool check) {
    if(!check) {
      return Container();
    }

    return const SizedBox(
      width: 80,
      height: 1,
      child: const DecoratedBox(
        decoration: const BoxDecoration(
            color: AppColors.DARK_700
        ),
      ),
    );
  }
}

