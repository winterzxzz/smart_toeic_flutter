import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final double height;
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.height = 50});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        // autofillHints: widget.isPassword
        //     ? [
        //         AutofillHints.password,
        //       ]
        //     : widget.labelText == S.current.email_label
        //         ? [
        //             AutofillHints.email,
        //           ]
        //         : null,
        keyboardType: widget.keyboardType,
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textGray,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: const TextStyle(color: AppColors.textGray),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.primary
                  : AppColors.textWhite,
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
