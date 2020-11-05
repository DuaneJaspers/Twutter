import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user;
  void _pushPost() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      setState(() {
        _user = user;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ' ' + _user.email),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushPost,
        tooltip: 'new Post',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: posts.get(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? LinearProgressIndicator()
              : _buildList(context, snapshot.data.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildRow(context, data)).toList(),
    );
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot snapshot) {
    final post = Post.fromSnapshot(snapshot);
    return Padding(
      key: ValueKey(post.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(post.content),
        ),
      ),
    );
  }
}
