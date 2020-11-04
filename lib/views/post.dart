import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: RaisedButton(onPressed: () {}, child: Text('Make Twut')))
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
