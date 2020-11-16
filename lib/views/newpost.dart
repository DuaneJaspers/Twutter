import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/util.dart';
import '../models/post.dart';
import '../API.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();

  int _counter = 0;
  String postContent;
  User user = FirebaseAuth.instance.currentUser;

  void _changePost(String value) {
    setState(() {
      _counter = value.length;
      postContent = value;
    });
  }

  void _savePost() async {
    print(postContent);
    List<String> tags = extractTags(postContent);
    print(user);
    List<String> likes;
    Post post = Post(postContent, tags, likes, user.uid);
    API.addPost(post);
    Navigator.pop(context, 'new twuut made!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child:
                    // TODO: style button
                    RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _savePost();
                          }
                        },
                        child: Text('Make Twut')))
          ],
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // TODO : display name and profile picture
                Text('${150 - _counter}',
                    style: (150 - _counter < 0)
                        ? TextStyle(color: Colors.red)
                        : null),
                // TODO: move to top
                // TODO: add _counter limit
                TextFormField(
                    controller: _postController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autocorrect: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Cannot make an empty post...';
                      }
                      if (value.length > 150) {
                        return 'Too many characters used...';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Post', alignLabelWithHint: false),
                    onChanged: (String value) => _changePost(value)),
              ],
            )));
  }
}
