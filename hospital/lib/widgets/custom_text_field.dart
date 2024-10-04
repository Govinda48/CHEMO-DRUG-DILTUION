import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final IconButton? suffixIcon; // Added suffixIcon parameter

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffixIcon, // Initialize suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        suffixIcon: suffixIcon, // Add suffixIcon to InputDecoration
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
