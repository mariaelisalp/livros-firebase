import 'package:flutter/material.dart';

class MyAlert extends StatelessWidget {

  const MyAlert({super.key,
    required this.title,
    required this.content,
    required this.actions,
    required this.titleColor
  });

  final String title;
  final String content;
  final List<Widget> actions;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          title,
          style: TextStyle(
            color: titleColor, 
            fontWeight: FontWeight.bold,
          ),
        ),
      content: Text(content),
      actions: actions,
    );
  }
}