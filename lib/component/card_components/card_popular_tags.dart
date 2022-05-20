import 'package:flutter/material.dart';
import 'package:france_partage/component/text_components/app_text.dart';

class CardPopularTags extends StatefulWidget {
  const CardPopularTags({Key? key}) : super(key: key);

  @override
  State<CardPopularTags> createState() => _CardPopularTagsState();
}

class _CardPopularTagsState extends State<CardPopularTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppText("TAGS"),
    );
  }
}
