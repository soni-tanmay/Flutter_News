import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/headlines/headlines_bloc.dart';
import 'package:news_app/common_components/search_bar.dart';
import 'package:news_app/screens/Intrest/intrest_screen.dart';
import 'package:news_app/services/sizeconfig.dart';
import 'package:news_app/utils/enums.dart';
import 'package:shimmer/shimmer.dart';

class HeadlinesScreen extends StatefulWidget {
  @override
  _HeadlinesScreenState createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen>
    with WidgetsBindingObserver {
  HeadlinesBloc headlinesBloc = HeadlinesBloc();
  TextEditingController textController;
  bool autoRefresh = false;
  Timer timer;
  AppLifecycleState appLifecycleState;
  String searchText = 'covid';
  bool isConnected = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && autoRefresh == true) {
      timer = Timer.periodic(Duration(seconds: 30), (timer) {
        if (searchText.isNotEmpty)
          headlinesBloc.add(FetchHeadlinesEvent(searchText));
      });
    }
    if (state == AppLifecycleState.paused) {
      timer?.cancel();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    textController = TextEditingController(text: searchText);
    headlinesBloc.add(FetchHeadlinesEvent(searchText));
    if (autoRefresh) {
      timer = Timer.periodic(Duration(seconds: 30), (timer) {
        if (searchText.isNotEmpty)
          headlinesBloc.add(FetchHeadlinesEvent(searchText));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.toHeight,
          title: Text('Headlines'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0.toWidth),
              child: Column(
                children: [
                  CupertinoSwitch(
                    value: autoRefresh,
                    onChanged: (b) {
                      setState(() {
                        autoRefresh = b;
                      });
                      if (autoRefresh) {
                        timer = Timer.periodic(Duration(seconds: 30), (timer) {
                          if (searchText.isNotEmpty)
                            headlinesBloc.add(FetchHeadlinesEvent(searchText));
                        });
                      } else {
                        timer?.cancel();
                      }
                    },
                  ),
                  Text('Autorefresh'),
                ],
              ),
            )
          ],
        ),
        bottomSheet: Container(
          width: SizeConfig().screenWidth,
          height: 60.toHeight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.toHeight),
            child: Center(
              child: InkWell(
                child: Text(
                  'See Intrest Over Time',
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onTap: () async {
                  var searchString =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => IntrestScreen(
                                searchText: searchText,
                              )));
                  if (searchString != null && searchString != '') {
                    headlinesBloc.add(FetchHeadlinesEvent(searchString));
                  }
                },
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            BlocListener(
              cubit: headlinesBloc,
              listener: (context, state) {
                if (state is FetchHeadlinesState) {
                  setState(() {
                    isConnected = headlinesBloc.isConnected;
                    if (!isConnected) {
                      textController.text = '';
                    }
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
                        'Connection Lost !\n Displaying Last Fetched Headlines.',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            SearchBar(
              textController: textController,
              onPressed: () {
                searchText = textController.text;
                if (searchText.isNotEmpty)
                  headlinesBloc.add(FetchHeadlinesEvent(searchText));
              },
            ),
            Expanded(
              child: BlocBuilder<HeadlinesBloc, HeadlinesState>(
                cubit: headlinesBloc,
                builder: (context, state) {
                  if (state.status == Status.SUCCESS) {
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          20.toWidth, 0, 20.toWidth, 80.toHeight),
                      itemCount: state.data.articles.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Container(
                                padding: EdgeInsets.only(right: 8.toWidth),
                                height: 120.toHeight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      state.data.articles[index].urlToImage,
                                      width: 120.toWidth,
                                      height: 120.toHeight,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: 20.toWidth,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.toHeight),
                                            child: Text(
                                              state.data.articles[index].title,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.toFont,
                                              ),
                                            ),
                                          ),
                                          state.data.articles[index].author !=
                                                      null &&
                                                  state.data.articles[index]
                                                          .author !=
                                                      ''
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.toHeight),
                                                  child: Text(
                                                    '- ${state.data.articles[index].author}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.toFont,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ],
                                )));
                      },
                    );
                  }
                  if (state.status == Status.EMPTY) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.toHeight),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.toFont,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (state.status == Status.ERROR) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.toHeight),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.toFont,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
                        itemCount: 10,
                        itemBuilder: (context, index) => Shimmer.fromColors(
                              baseColor: Colors.grey[700],
                              highlightColor: Colors.grey[100],
                              child: Card(
                                color: Colors.white,
                                child: Container(
                                  height: 100.toHeight,
                                ),
                              ),
                            ));
                  }
                },
              ),
            ),
          ],
        ));
  }
}
