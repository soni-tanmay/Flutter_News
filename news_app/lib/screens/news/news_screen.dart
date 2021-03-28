import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}
