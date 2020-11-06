import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twutter/models/post.dart';

final CollectionReference posts =
    FirebaseFirestore.instance.collection('posts');

// List<Post> getPosts() {
//   List<Post> postsList = [];
//   posts.get().then((QuerySnapshot qs) => {
//         qs.docs.forEach((DocumentSnapshot doc) {
//           postsList.add(Post.fromSnapshot(doc));
//         })
//       });
//   return postsList;
// }

Future<void> addPost(Post post) {
  return posts
      .add({
        'content': post.content,
        'tags': post.tags,
        'likes': post.likes,
        'date': post.date,
        'uid': post.uid,
      })
      .then((value) => print("post added"))
      .catchError((error) => print("Failed to add user: $error"));
}
