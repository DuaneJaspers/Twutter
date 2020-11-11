import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateThenDisplayMessage(context);
      },
      child: Text('Login'),
    );
  }

  void _navigateThenDisplayMessage(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/login');
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    }
    if (Scaffold.of(context).isDrawerOpen) Navigator.of(context).pop();
  }
}
