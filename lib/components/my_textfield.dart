import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      this.error,
      required this.hintText,
      this.focusNode,
      required this.obscureText,
      required this.keyboardType,
      this.onChanged
      });
  final controller;
  final bool? error;
  final focusNode;
  final String hintText;
  final bool obscureText;
  final keyboardType;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: error == true ? Colors.red : Colors.purple.shade300, width: 2.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
           borderSide: BorderSide(color: error == true ? Colors.red : Colors.purple.shade300, width: 2.5),
          ),
          fillColor: const Color.fromARGB(151, 255, 255, 255),
          filled: true,
          hintText: hintText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
