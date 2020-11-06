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
    final result = await Navigator.pushNamed(context, '/post');
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    }
  }
}
