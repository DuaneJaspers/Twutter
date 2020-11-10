import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';
import 'package:twutter/models/profile.dart';
import '../API.dart';

class TwuutList extends StatefulWidget {
  TwuutList({Key key, this.filters}) : super(key: key);
  final List<String> filters;
  @override
  _TwuutListState createState() => _TwuutListState();
}

class _TwuutListState extends State<TwuutList> {
  Stream<QuerySnapshot> data;
  var initialData;

  @override
  void initState() {
    super.initState();
    var filters = widget.filters ?? [];
    if (filters.isEmpty) {
      initialData = API.posts.orderBy('date', descending: true);
    } else {
      initialData = API.posts
          .where('uid', whereIn: filters)
          .orderBy('date', descending: true);
    }
    data = initialData.snapshots();
  }

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
    return RefreshIndicator(
        child: _buildBody(context), onRefresh: _refreshData);

    // return Text('hi');
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            print('refresh');
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
    final post = Post.fromSnapshot(widget.snapshot);
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
