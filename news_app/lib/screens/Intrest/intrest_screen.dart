import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/news/news_bloc.dart';
import 'package:news_app/common_components/search_bar.dart';
import 'package:news_app/services/sizeconfig.dart';

class IntrestScreen extends StatefulWidget {
  @override
  _IntrestScreenState createState() => _IntrestScreenState();
}

class _IntrestScreenState extends State<IntrestScreen> {
  NewsBloc newsBloc = NewsBloc();
  TextEditingController textController = TextEditingController();
  bool autoRefresh = false;
  Timer timer;
  AppLifecycleState appLifecycleState;
  String searchText;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.toHeight,
          title: Text('Intrests'),
          centerTitle: true,
        ),
        bottomSheet: Container(
          width: SizeConfig().screenWidth,
          height: 60.toHeight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.toHeight),
            child: Center(
              child: InkWell(
                child: Text(
                  'See Headlines',
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            BlocListener(
              cubit: newsBloc,
              listener: (context, state) {
                if (state is FetchHeadlinesState) {
                  setState(() {
                    isConnected = newsBloc.isConnected;
                  });
                }
              },
              child: isConnected
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 10.toHeight),
                      width: SizeConfig().screenWidth,
                      color: Colors.red,
                      child: Text(
                        'Connection Lost !\n Displaying Last Fetched Intrests.',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            SearchBar(
              textController: textController,
              onPressed: () {
                searchText = textController.text;
                newsBloc.add(FetchHeadlinesEvent(searchText));
              },
            ),
          ],
        ));
  }
}
