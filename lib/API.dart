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
          'tags': post.tags ?? [],
          'likes': post.likes ?? [],
          'date': post.date,
          'uid': post.uid,
        })
        .then((value) => print("post added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<void> changePost(Post post) {
    return posts
        .doc(post.reference.id.toString())
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

  static Future<void> togglePostLike(Post post, String uid) {
    List<dynamic> likes = post.likes ?? [];
    print(post.reference.id);
    likes.contains(uid) ? likes.remove(uid) : likes.add(uid);
    return posts
        .doc(post.reference.id)
        .update({
          'likes': likes,
        })
        .then((value) => print("changed"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<void> saveProfile(Profile profile) {
    return profiles
        .doc(profile.reference ?? profile.uid)
        .set({
          'displayName': profile.displayName,
          'photoUrl': profile.photoUrl,
          'following': profile.following ?? [],
        })
        .then((value) => (print('user added')))
        .catchError((onError) => print('something failed $onError'));
  }

  static Future<void> toggleFollowing(String uid, Profile profile) {
    List<dynamic> following = profile.following ?? [];
    following.contains(uid) ? following.remove(uid) : following.add(uid);
    print(profile.reference.id);
    return profiles
        .doc(profile.reference.id)
        .update({
          'following': following,
        })
        .then((value) => print("changed"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
