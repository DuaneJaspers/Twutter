import 'dart:ffi';

import 'package:flutter/material.dart';

typedef void StringCallback(String value);

class SearchTextField extends StatelessWidget {
  final StringCallback onSearch;

  SearchTextField({@required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white30,
            border: Border.all(
              color: Colors.white38,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: TextField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onSubmitted: (String value) {
            onSearch(value);
          },
          decoration: new InputDecoration.collapsed(hintText: 'Search Twutter'),
        ));
  }
}
