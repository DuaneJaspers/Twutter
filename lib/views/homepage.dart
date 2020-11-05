import 'package:flutter/material.dart';
import 'package:twutter/API.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _pushPost() {
    getPosts();
    Navigator.pushNamed(context, '/post');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the homepage placeholder',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushPost,
        tooltip: 'new Post',
        child: Icon(Icons.add),
      ),
    );
  }
}
