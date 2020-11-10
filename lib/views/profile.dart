import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/widgets/twuutList.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = 'profile';
  bool ownProfile = false;

  @override
  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context).settings.arguments.toString();

    if (uid == FirebaseAuth.instance.currentUser.uid) {
      setState(() {
        displayName = FirebaseAuth.instance.currentUser.displayName;
        ownProfile = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Column(
        children: [
          Text('$displayName'),
          Expanded(
              child: SizedBox(
                  child: TwuutList(
            filters: [uid],
          ))),
          // TwuutList(),
        ],
      ),
    );
  }
}
