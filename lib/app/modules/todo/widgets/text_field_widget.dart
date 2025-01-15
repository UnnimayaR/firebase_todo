import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap ?? () {},
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
