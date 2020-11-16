import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/profile.dart';

import '../helpers/enum.dart';
import '../widgets/twuutList.dart';
import '../widgets/buttons/login_button.dart';
import '../widgets/buttons/logout_button.dart';
import '../widgets/buttons/new_post_fab.dart';
import '../widgets/buttons/register_button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user;
  int _selectedIndex = 0;
  Profile _profile;
  Stream profile;
  String title = "homepage";

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) _setProfileAsync(_user);
    FirebaseAuth.instance.authStateChanges().listen((User firebaseUser) {
      if (firebaseUser != null) {
        _setProfileAsync(firebaseUser);
      } else {
        setState(() {
          _user = firebaseUser;
          _profile = null;
        });
      }
    });
  }

  void _setProfileAsync(User user) async {
    API.profiles.doc(user.uid).snapshots().listen((DocumentSnapshot snapshot) {
      print('Profile changed');
      print('snapshot $snapshot');
      setState(() {
        _profile = Profile.fromSnapshot(snapshot);
        _user = user;
      });
    });
  }

  Widget _changeTab(context, index) {
    navTabsEnum tab = navTabsEnum.values[index];
    switch (tab) {
      case navTabsEnum.homepage:
        return TwuutList(key: Key('homepage'));
        break;
      case navTabsEnum.following:
        return _buildFollowing(context);
        break;
      default:
        return TwuutList(key: Key('homepage'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      title = index == 0 ? 'homepage' : 'following';
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile',
                    arguments: FirebaseAuth.instance.currentUser.uid);
              },
              child: Column(children: <Widget>[
                Text(
                  _profile != null ? '@${_profile.displayName}' : '',
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          (_user != null)
              ? Column(children: [
                  LogoutButton(),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile',
                          arguments: FirebaseAuth.instance.currentUser.uid);
                    },
                    child: Text('Profile'),
                  )
                ])
              : Row(
                  children: [LoginButton(), RegisterButton()],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
        ]),
      ),
      appBar: AppBar(
        title: Text('${widget.title}  $title'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _changeTab(context, _selectedIndex),
      floatingActionButton: NewPostFAB(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'following'),
          ],
          currentIndex: _selectedIndex,
          // TODO : use theme to set colors...
          unselectedItemColor: Colors.white30,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped),
    );
  }

// TODO: move to own class
  Widget _buildFollowing(BuildContext context) {
    setState(() {
      title = 'following';
    });
    if (_profile == null)
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please log in to see your following list',
                textAlign: TextAlign.center,
              ),
              LoginButton(),
            ],
          ));

    if (_profile.following.isEmpty) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "You're not following anyone yet...",
                textAlign: TextAlign.center,
              ),
            ],
          ));
    }
    print(_profile.following);
    return TwuutList(
      key: Key('following'),
      filters: List<String>.from(_profile.following),
    );
    // return
  }
}
