import 'package:devconnect/theme/theme.dart';
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor = Pallete.backgroundColor,
    this.textColor = Pallete.whiteColor,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: Text(label),
        backgroundColor: backgroundColor,
        labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
