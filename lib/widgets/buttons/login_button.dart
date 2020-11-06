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
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }
}
