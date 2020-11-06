import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twutter/helpers/util.dart';
import '../models/post.dart';
import '../API.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _counter = 0;
  String postContent;
  User user = FirebaseAuth.instance.currentUser;

  void _changePost(String value) {
    setState(() {
      _counter = value.length;
      postContent = value;
    });
  }

  void _savePost() {
    List<String> tags = extractTags(postContent);
    print(user);
    Post post = Post(postContent, tags, user.uid);
    addPost(post);
    Navigator.pop(context, 'new twuut made!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child:
                    // TODO: style button
                    RaisedButton(
                        onPressed: _savePost, child: Text('Make Twut')))
          ],
        ),
        body: Column(
          children: <Widget>[
            // TODO : display name and profile picture
            Text('$_counter = $postContent'),
            // TODO: move to top
            // TODO: add _counter limit
            TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: 'Post', alignLabelWithHint: false),
                onChanged: (String value) => _changePost(value)),
          ],
        ));
  }
}
