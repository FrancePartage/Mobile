import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';
import 'package:france_partage/resources/app_colors.dart';

class AppTag extends StatefulWidget {
  final String tag;
  const AppTag({Key? key, required this.tag}) : super(key: key);

  @override
  State<AppTag> createState() => _AppTagState();
}

class _AppTagState extends State<AppTag> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.BLUE,
              AppColors.CYAN,
            ],
          )
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
          child: AppText(
            widget.tag,
            color: AppColors.WHITE,
          ),
        ),
      ),
      onTap: goToTagSearch,
    );
  }

  goToTagSearch() {
    print("Recherche de : #" + widget.tag);
  }
}
