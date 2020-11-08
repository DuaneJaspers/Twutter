import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/widgets/formsFields/displayname_field.dart';
import 'package:twutter/widgets/formsFields/email_field.dart';
import 'package:twutter/widgets/formsFields/password_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                DisplayNameField(displayNameController: _displayNameController),
                EmailField(emailController: _emailController),
                PasswordField(passwordController: _passwordController),
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
                if (_error != null)
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '$_error',
                      style: TextStyle(color: Colors.red),
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
      user.updateProfile(displayName: _displayNameController.text);
      Navigator.pop(context, 'Registration succesfull');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = ('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        error = ('the account already exists for that email.');
      }
    } catch (e) {
      error = ('different error : $e');
    }
    if (error != null) {
      setState(() {
        _error = error;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
