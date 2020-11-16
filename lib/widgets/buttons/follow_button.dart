import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/profile.dart';

class FollowButton extends StatelessWidget {
  FollowButton(this.uid, this.profile, this.followed);
  final String uid;
  final Profile profile;
  final bool followed;
  @override
  Widget build(BuildContext context) {
    if (this.followed) {
      return OutlinedButton(
        onPressed: () {
          _toggleFollow();
        },
        child: Text('unfollow'),
      );
    }
    return ElevatedButton(
      onPressed: () {
        _toggleFollow();
      },
      child: Text('Follow'),
    );
  }

  _toggleFollow() async {
    API.toggleFollowing(uid, profile);
  }
}
