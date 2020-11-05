import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/widgets/formsFields/email_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _error;

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New user'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EmailField(emailController: _emailController),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'please enter a password';
                    }
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _register();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    _error == null ? '' : '$_error',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/post');
                    },
                    child: Text('New Post'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/post');
                    },
                    child: Text('New Post'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            )));
  }

  void _register() async {
    User user;
    String error;
    try {
      UserCredential userCredential =
          (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ));
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // TODO : display error
        error = ('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        // TODO : display error
        error = ('the account already exists for that email.');
      }
    } catch (e) {
      error = ('different error : $e');
    }

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
        _error = error;
      });
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
