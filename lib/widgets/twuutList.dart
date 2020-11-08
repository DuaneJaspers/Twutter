import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';

class TwuutList extends StatefulWidget {
  @override
  _TwuutListState createState() => _TwuutListState();
}

// TODO make list lazy
class _TwuutListState extends State<TwuutList> {
  var data = posts.get();

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  void fetchPosts() async {
    setState(() {
      data = posts.get();
    });
  }

  Future<void> _getData() async {
    setState(() {
      fetchPosts();
    });
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: data,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? LinearProgressIndicator()
              : _buildList(context, snapshot.data.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return RefreshIndicator(
        child: ListView(
          shrinkWrap: true,
          children: snapshot.map((data) => _buildRow(context, data)).toList(),
        ),
        onRefresh: _getData);
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
          subtitle: Text(post.date.toDate().toString()),
        ),
      ),
    );
  }
}
