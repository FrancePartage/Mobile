import 'package:flutter/material.dart';

class SafePadding extends StatelessWidget {
  final double? paddingValue;
  const SafePadding({Key? key, this.paddingValue = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: paddingValue!)
    );
  }
}
