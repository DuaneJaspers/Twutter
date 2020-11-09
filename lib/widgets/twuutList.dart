import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';
import 'package:twutter/models/profile.dart';
import '../API.dart';

class TwuutList extends StatefulWidget {
  @override
  _TwuutListState createState() => _TwuutListState();
}

// TODO make list lazy
class _TwuutListState extends State<TwuutList> {
  final initialData = posts.orderBy('date', descending: true).get();
  var data = posts.orderBy('date', descending: true).get();
  var reload = false;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  void fetchPosts() async {
    setState(() {
      data = initialData;
      reload = true;
    });
  }

  Future<void> _getData() async {
    setState(() {
      fetchPosts();
    });
  }

  Widget _buildBody(BuildContext context) {
    if (reload) {
      setState(() {
        reload = false;
      });
      return CircularProgressIndicator();
    } else {
      return FutureBuilder<QuerySnapshot>(
          future: data,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? LinearProgressIndicator()
                : _buildList(context, snapshot.data.docs);
          });
    }
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return RefreshIndicator(
        child: ListView(
          shrinkWrap: true,
          children: snapshot.map((data) => PostWidget(snapshot: data)).toList(),
        ),
        onRefresh: _getData);
  }
}

class PostWidget extends StatefulWidget {
  PostWidget({this.snapshot});

  final DocumentSnapshot snapshot;
  @override
  _PostWidgetState createState() => _PostWidgetState(snapshot: snapshot);
}

class _PostWidgetState extends State<PostWidget> {
  _PostWidgetState({this.snapshot});

  final DocumentSnapshot snapshot;
  Profile profile;
  bool liked = false;

  void _getProfile(uid) async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('profiles').doc(uid).get();

    Profile profileData = Profile.fromSnapshot(docSnapshot);
    if (mounted) {
      setState(() {
        profile = profileData;
      });
    }
  }

  void _toggleLiked() async {
    // TODO change db entry
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = Post.fromSnapshot(snapshot);
    _getProfile(post.uid);
    return Padding(
      key: ValueKey(post.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(children: [
          (profile != null
              ? Text(profile.displayName)
              : CircularProgressIndicator()),
          Text(post.content),
          Text(post.date.toDate().toString()),
          IconButton(
            icon: Icon(Icons.thumb_up),
            color: liked ? Colors.red[300] : Colors.black,
            onPressed: () {
              _toggleLiked();
            },
          )
        ]),
      ),
    );
  }
}
