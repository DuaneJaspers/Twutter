import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twutter/views/search.dart';

import 'views/profilePage.dart';
import 'views/login.dart';
import 'views/register.dart';
import 'views/newpost.dart';
import 'views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TwutterApp());
}

class TwutterApp extends StatefulWidget {
  @override
  _TwutterAppState createState() => _TwutterAppState();
}

class _TwutterAppState extends State<TwutterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: "Twutter"),
        '/post': (context) => PostPage(title: "New post"),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
        '/search': (context) => SearchPage(),
        // TODO : forgot password
      },
    );
  }
}
