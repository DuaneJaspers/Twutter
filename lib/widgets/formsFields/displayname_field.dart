import 'package:flutter/material.dart';

class DisplayNameField extends StatelessWidget {
  DisplayNameField({this.displayNameController});

  final TextEditingController displayNameController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: displayNameController,
      decoration: const InputDecoration(labelText: 'display name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'please enter a display name';
        } else if (value.length > 15) {
          return 'display name is too long';
        }
        return null;
      },
    );
  }
}
