import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/API.dart';
import 'package:twutter/models/post.dart';
import 'package:twutter/widgets/buttons/login_button.dart';
import 'package:twutter/widgets/buttons/new_post_fab.dart';

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
    switch (index) {
      case 0:
        return _buildBody(context);
        break;
      case 1:
        return _buildFollowing(context);
        break;
      case 2:
        return _buildBody(context);
        break;
      default:
        return _buildBody(context);
    }
  }

  static const List<Widget> _tabOptions = <Widget>[
    Text('page 1'),
    Text('page 2'),
    Text('page 3'),
  ];

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
            child: Text(
              'Menu',
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          LoginButton(),
        ]),
      ),
      appBar: AppBar(
        title: Text(widget.title + ' ' + _user.email),
        actions: [],
      ),
      body: _changeTab(context, _selectedIndex),
      floatingActionButton: NewPostFAB(),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'following'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: posts.get(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? LinearProgressIndicator()
              : _buildList(context, snapshot.data.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildRow(context, data)).toList(),
    );
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot snapshot) {
    final post = Post.fromSnapshot(snapshot);
    return Padding(
      key: ValueKey(post.reference),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(post.content),
          subtitle: Text(post.date.toDate().toString()),
        ),
      ),
    );
  }

  Widget _buildFollowing(BuildContext context) {
    return (Text('following page'));
  }
}
