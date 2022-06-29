import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final bool? obscureText;
  final double? sizeRatio;

  const AppTextField({Key? key, required this.labelText, required this.hintText, required this.textController, this.obscureText = false, this.sizeRatio = 0.7}) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: (size.width * widget.sizeRatio!),
      child: TextField(
        obscureText: widget.obscureText!,
        keyboardType: TextInputType.text,
        controller: widget.textController,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}

