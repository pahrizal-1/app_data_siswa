import 'package:flutter/material.dart';

class CostumeButtons extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color colorBg;
  const CostumeButtons(
      {super.key, this.onPressed, required this.title, required this.colorBg});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: colorBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
