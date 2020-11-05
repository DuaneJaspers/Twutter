import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String content;
  final List<String> tags;
  final DocumentReference reference;
  final List likes;
  final DateTime date;
  final User user;

  Post(String postContent, List<String> postTags, User postUser,
      {this.reference})
      : assert(postContent != null),
        content = postContent,
        likes = null,
        date = DateTime.now(),
        tags = postTags,
        user = postUser;

  Post.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        content = map['content'],
        date = DateTime(map['date']),
        likes = map['likes'],
        tags = map['tags'].toString().isEmpty
            ? List<String>.from(map['tags'])
            : null,
        user = null;

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
