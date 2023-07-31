import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData iconData;
  final String? suffikIcon;
  final String hintText;
  final bool obscureText;

  const CustomTextField(
      {Key? key,
      this.controller,
      required this.iconData,
      required this.hintText,
      this.obscureText = false,
      this.suffikIcon = ''})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email Tidal Boleh Kosong';
        }
        return null;
      },
      controller: widget.controller,
      focusNode: myFocusNode,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.iconData),
        prefixIconColor: Colors.deepPurple,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusColor: Colors.deepPurple,
        labelText: widget.hintText,
        labelStyle: TextStyle(
          color: myFocusNode.hasFocus
              ? Colors.deepPurple
              : const Color(0xff231F20),
        ),
      ),
    );
  }
}
