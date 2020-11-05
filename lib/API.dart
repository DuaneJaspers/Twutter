import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twutter/models/post.dart';

final CollectionReference posts =
    FirebaseFirestore.instance.collection('posts');

void getPosts() {
  posts.get().then((QuerySnapshot qs) => {
        qs.docs.forEach((element) {
          print(element['content']);
        })
      });
}

Future<void> addPost(Post post) {
  return posts
      .add({
        'content': post.content,
        'tags': post.tags,
      })
      .then((value) => print("post added"))
      .catchError((error) => print("Failed to add user: $error"));
}
