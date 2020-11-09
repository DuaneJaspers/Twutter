import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twutter/models/post.dart';
import 'package:twutter/models/profile.dart';

class API {
  static final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  static final CollectionReference profiles =
      FirebaseFirestore.instance.collection('profiles');
// List<Post> getPosts() {
//   List<Post> postsList = [];
//   posts.get().then((QuerySnapshot qs) => {
//         qs.docs.forEach((DocumentSnapshot doc) {
//           postsList.add(Post.fromSnapshot(doc));
//         })
//       });
//   return postsList;
// }

  static Future<void> addPost(Post post) {
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

  static Future<void> changePost(Post post) {
    return posts
        .doc(post.reference.toString())
        .set({
          'content': post.content,
          'tags': post.tags,
          'likes': post.likes,
          'date': post.date,
          'uid': post.uid,
        })
        .then((value) => print("post added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<void> saveProfile(Profile profile) {
    return profiles
        .doc(profile.reference ?? profile.uid)
        .set({
          'displayName': profile.displayName,
          'photoUrl': profile.photoUrl,
          'following': profile.following,
        })
        .then((value) => (print('user added')))
        .catchError((onError) => print('something failed $onError'));
  }
}
