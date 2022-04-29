import 'package:flutter/material.dart';

class AppTextDrawer extends StatelessWidget {
  const AppTextDrawer({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width /6, 0, 0, 0),
        child: TextButton(
          onPressed: null,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    );
  }
}
