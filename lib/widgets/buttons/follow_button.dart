import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/profile.dart';

class FollowButton extends StatelessWidget {
  FollowButton(this.uid, this.profile);
  final String uid;
  final Profile profile;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _followUser();
      },
      child: Text('Follow'),
    );
  }

  _followUser() async {
    API.toggleFollowing(uid, profile);
  }
}
