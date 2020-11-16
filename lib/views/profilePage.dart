import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/profile.dart';
import 'package:twutter/widgets/buttons/follow_button.dart';
import 'package:twutter/widgets/twuutList.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName;
  bool ownProfile = false;
  String _uid;
  Profile _userProfile;
  bool loading = true;

  Future<void> _getProfileAsync(String uid) async {
    if (_uid == FirebaseAuth.instance.currentUser.uid) {
      if (mounted) {
        setState(() {
          displayName = FirebaseAuth.instance.currentUser.displayName;
          ownProfile = true;
          loading = false;
        });
        return;
      }
    }
    Profile profile = Profile.fromSnapshot(await API.profiles.doc(uid).get());
    Profile userProfile = Profile.fromSnapshot(
        await API.profiles.doc(FirebaseAuth.instance.currentUser.uid).get());
    print('calls');
    if (mounted) {
      setState(() {
        _userProfile = userProfile;
        displayName = profile.displayName;
        loading = false;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    _uid = ModalRoute.of(context).settings.arguments.toString();
    loading ? _getProfileAsync(_uid) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Text('$displayName'),
              if (!ownProfile)
                _userProfile != null
                    ? FollowButton(
                        _uid,
                        _userProfile,
                        _userProfile.following.isNotEmpty
                            ? _userProfile.following.contains(_uid)
                            : false)
                    : CircularProgressIndicator(),
            ],
          ),

          Expanded(
              child: SizedBox(
                  child: TwuutList(
            filters: [_uid],
          ))),
          // TwuutList(),
        ],
      ),
    );
  }
}
