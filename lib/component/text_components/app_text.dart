import 'package:flutter/material.dart';
import '../../resources/app_colors.dart';

class AppText extends StatelessWidget {

  final String text;
  final double size;
  final FontWeight fontWeight ;
  final Color color;
  final TextAlign textAlign;

  const AppText(this.text,{Key? key, this.size = 12, this.fontWeight = FontWeight.normal, this.color = AppColors.DARK_900, this.textAlign = TextAlign.justify}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}
