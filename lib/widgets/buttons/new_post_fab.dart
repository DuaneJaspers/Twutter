import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPostFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _pushPostThenDisplayMessage(context);
      },
      tooltip: 'new Post',
      child: Icon(Icons.add),
    );
  }

  void _pushPostThenDisplayMessage(context) async {
    final result = FirebaseAuth.instance.currentUser == null
        ? await Navigator.pushNamed(context, '/login')
        : await Navigator.pushNamed(context, '/post');
    if (result == 'new twuut made!') {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    } else if (result == 'login successful') {
      _pushPostThenDisplayMessage(context);
    }
  }
}
