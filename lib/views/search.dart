import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twutter/widgets/twuutList.dart';
import '../widgets/formsFields/search_field.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.hashtag});
  final String hashtag;

  @override
  _SearchPageState createState() => _SearchPageState(searchQuery: hashtag);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState({this.searchQuery});
  String searchQuery;
  bool loading = false;
  void searchString(String value) {
    print('searching');
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchQuery = value;
          loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchTextField(
          onSearch: (String value) {
            searchString(value);
          },
        ),
      ),
      body: searchQuery != null
          ? (loading
              ? CircularProgressIndicator()
              : TwuutList(
                  key: Key('search'),
                  searchQuery: searchQuery,
                ))
          : Text("Enter a #keyword to start searching"),
    );
  }
}
