import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? Function(String? value)? validator;
  const PasswordField({
    Key? key,
    required this.hintText,
    required this.textInputAction,
    required this.controller,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      width: 80.w,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: isPasswordVisible,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: IconButton(
            color: AppColor.blue,
            icon: isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          filled: true,
          fillColor: AppColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
