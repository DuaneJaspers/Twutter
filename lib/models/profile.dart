import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String displayName;
  String photoUrl;
  DocumentReference reference;
  List<dynamic> following;
  String uid;

  Profile(name, photo, followingList, refUid, {this.reference})
      : assert(name != null),
        displayName = name,
        photoUrl = photo,
        following = followingList,
        uid = refUid;

  Profile.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        displayName = map['displayName'],
        photoUrl = map['photoUrl'],
        following = map['following'];

  // user = null;

  Profile.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() {
    return ('displayName $displayName following ${following.toString()}');
  }
}
