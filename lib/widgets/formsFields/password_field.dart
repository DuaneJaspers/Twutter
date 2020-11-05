import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  PasswordField({this.passwordController, this.obscureText = false});

  final TextEditingController passwordController;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: passwordController,
      decoration: const InputDecoration(labelText: 'password'),
      // TODO : move validation to passwordValidator
      validator: (String value) {
        if (value.isEmpty) {
          return 'please enter a password';
        }
        return null;
      },
    );
  }
}
