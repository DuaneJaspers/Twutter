import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String content;
  final List<dynamic> tags;
  final DocumentReference reference;
  final List<dynamic> likes;
  final Timestamp date;
  final String uid;

  Post(String postContent, List<dynamic> postTags, List<dynamic> postLikes,
      String postUid,
      {this.reference})
      : assert(postContent != null),
        content = postContent,
        likes = postLikes,
        date = Timestamp.now(),
        tags = postTags.isEmpty ? null : postTags,
        uid = postUid;
  // user = postUser;

  Post.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        content = map['content'],
        date = map['date'],
        likes = map['likes'],
        tags = map['tags'],
        uid = map['uid'];

  // user = null;

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
