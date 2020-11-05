import 'package:flutter/material.dart';
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

  void _changePost(String value) {
    setState(() {
      _counter = value.length;
      postContent = value;
    });
  }

  void _savePost() {
    List<String> tags;
    Post post = Post(postContent, tags);
    addPost(post);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: RaisedButton(
                    onPressed: _savePost, child: Text('Make Twut')))
          ],
        ),
        body: Column(
          children: <Widget>[
            Text('$_counter = $postContent'),
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
