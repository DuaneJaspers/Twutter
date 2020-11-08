import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateThenDisplayMessage(context);
      },
      child: Text('Log out'),
    );
  }

  void _navigateThenDisplayMessage(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Log out succesfull")));
    Navigator.of(context).pop();
  }
}
