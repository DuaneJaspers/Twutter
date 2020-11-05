import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String content;
  final List<String> tags;
  final DocumentReference reference;

  Post(String postContent, List<String> postTags, {this.reference})
      : assert(postContent != null),
        content = postContent,
        tags = postTags;

  Post.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        content = map['content'],
        tags = map['tags'];

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
