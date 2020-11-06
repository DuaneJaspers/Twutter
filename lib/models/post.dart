import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String content;
  final List<String> tags;
  final DocumentReference reference;
  final List<String> likes;
  final Timestamp date;
  final String uid;

  Post(String postContent, List<String> postTags, String postUid,
      {this.reference})
      : assert(postContent != null),
        content = postContent,
        likes = [],
        date = Timestamp.now(),
        tags = postTags,
        uid = postUid;
  // user = postUser;

  Post.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        content = map['content'],
        date = map['date'],
        likes = List<String>.from(map['likes']),
        tags = List<String>.from(map['tags']),
        uid = map['uid'];

  // user = null;

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
