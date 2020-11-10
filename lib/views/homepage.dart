import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Widget _changeTab(context, index) {
    navTabsEnum tab = navTabsEnum.values[index];
    switch (tab) {
      case navTabsEnum.homepage:
        return TwuutList();
        break;
      case navTabsEnum.following:
        return _buildFollowing(context);
        break;
      default:
        return TwuutList();
    }
  }

  void _onItemTapped(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      setState(() {
        _user = user;
      });
    });
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
                  _user != null ? '@${_user.displayName}' : '',
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
        title: Text(widget.title),
        actions: [],
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
    return (Text('following page'));
  }
}
