import 'package:devconnect/theme/theme.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function() onTap;
  final String hintText;
  const AuthField(
      {super.key, required this.controller, required this.hintText, required this.onChanged, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap:onTap,
      onChanged: onChanged,
      controller: controller,
      obscureText: hintText == "Password" ? true : false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Pallete.blueColor,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Pallete.greyColor,
          ),
        ),
        contentPadding: EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Pallete.greyColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
