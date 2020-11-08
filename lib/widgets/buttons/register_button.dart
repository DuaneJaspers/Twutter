import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateThenDisplayMessage(context);
      },
      child: Text('Register'),
    );
  }

  void _navigateThenDisplayMessage(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/register');
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
    Navigator.of(context).pop();
  }
}
