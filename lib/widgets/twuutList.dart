import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';
import 'package:twutter/models/profile.dart';
import '../API.dart';

class TwuutList extends StatefulWidget {
  TwuutList({Key key, this.filters, this.searchQuery}) : super(key: key);
  final List<String> filters;
  final String searchQuery;

  @override
  _TwuutListState createState() => _TwuutListState();
}

class _TwuutListState extends State<TwuutList> {
  Stream<QuerySnapshot> data;
  var initialData;
  // String searchQuery;

  void _fetchPosts() {
    setState(() {
      data = initialData.snapshots();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchQuery = widget.searchQuery;
    var filters = widget.filters ?? [];
    if (filters.isEmpty && searchQuery == null) {
      initialData = API.posts.orderBy('date', descending: true);
    } else if (filters.isNotEmpty && searchQuery == null) {
      initialData = API.posts
          .where('uid', whereIn: filters)
          .orderBy('date', descending: true);
    } else if (filters.isEmpty && searchQuery != null) {
      initialData = API.posts
          .orderBy('date', descending: true)
          .where('tags', arrayContains: searchQuery);
    } else {
      initialData = API.posts
          .where('content', arrayContains: searchQuery)
          .where('uid', whereIn: filters)
          .orderBy('date', descending: true);
    }
    data = initialData.snapshots();
    return RefreshIndicator(
        child: _buildBody(context), onRefresh: _refreshData);

    // return Text('hi');
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return LinearProgressIndicator();
          } else {
            return _buildList(context, snapshot.data.docs);
          }
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      children: snapshot.map((data) => PostWidget(snapshot: data)).toList(),
    );
  }
}

class PostWidget extends StatefulWidget {
  PostWidget({this.snapshot});

  final DocumentSnapshot snapshot;
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Profile profile;
  bool liked;
  User user;
  Post post;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    post = Post.fromSnapshot(widget.snapshot);
    _getProfile(post.uid);
    liked = (user != null && post.likes != null)
        ? post.likes.contains(user.uid)
        : false;

    FirebaseAuth.instance.authStateChanges().listen((User firebaseUser) {
      if (mounted) return;
      user = firebaseUser;
      liked = (user != null && post.likes != null)
          ? post.likes.contains(user.uid)
          : false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    if (user == null) {
      var result = await Navigator.pushNamed(context, '/login');
      if (result == null) {
        return;
      }
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    }
    if (post.uid == user.uid) {
      // user cannot like own post
      return;
    }
    await API.togglePostLike(post, user.uid);
    if (mounted) {
      setState(() {
        liked = !liked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ? GestureDetector(
                  child: Text(
                    profile.displayName,
                    textScaleFactor: 1.2,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile',
                        arguments: post.uid);
                  },
                )
              : CircularProgressIndicator()),
          Text(post.content),
          Text(post.date.toDate().toString()),
          Row(children: [
            Text(post.likes != null ? post.likes.length.toString() : '0'),
            IconButton(
              icon: Icon(Icons.thumb_up),
              color: liked ? Colors.red[300] : Colors.black,
              onPressed: () {
                _toggleLiked();
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
