import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/widgets/buttons/register_button.dart';
import 'package:twutter/widgets/formsFields/email_field.dart';
import 'package:twutter/widgets/formsFields/password_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text("Login with password and email"),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
            ),
            EmailField(emailController: _emailController),
            PasswordField(
              passwordController: _passwordController,
              obscureText: true,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      child: Text("login"),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _signInWithEmailAndPassword();
                        }
                      },
                    ),
                    RegisterButton()
                  ]),
            ),
            if (_error != null)
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_error',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    String error;
    try {
      final User _ = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;

      Navigator.pop(context, "login successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = ('No user found for that email');
      } else if (e.code == 'wrong-password') {
        error = ('Wrong password provided for that user');
      }
      setState(() {
        _error = error;
      });
    }
  }
}
