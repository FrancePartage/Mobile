import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_tag.dart';

class AppTagSelector extends StatefulWidget {
  final List<String> tagsList;
  final Function callbackRemoveTag;

  const AppTagSelector({Key? key, required this.tagsList, required this.callbackRemoveTag}) : super(key: key);

  @override
  State<AppTagSelector> createState() => _AppTagSelectorState();
}

class _AppTagSelectorState extends State<AppTagSelector> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.6,
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getTagsList(),
        ),
      ),
    );
  }

  List<Widget> getTagsList() {
    List<Widget> result = [];

    for(var tag in widget.tagsList) {
      result.add(
        AppTag(tag: tag, callback: widget.callbackRemoveTag,)
      );
      result.add(
        Padding(padding: EdgeInsets.only(left: 10))
      );
    }

    return result;
  }
}
