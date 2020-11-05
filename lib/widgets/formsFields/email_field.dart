import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  EmailField({this.emailController});

  // Fields in a Widget subclass are always marked "final".

  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(labelText: 'email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'please enter an email';
        }
        return null;
      },
    );
  }
}
