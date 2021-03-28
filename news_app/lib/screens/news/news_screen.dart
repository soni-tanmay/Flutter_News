import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/news/news_bloc.dart';
import 'package:news_app/common_components/search_bar.dart';
import 'package:news_app/services/sizeconfig.dart';
import 'package:news_app/utils/enums.dart';
import 'package:shimmer/shimmer.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsBloc newsBloc = NewsBloc();
  TextEditingController textController = TextEditingController();
  bool autoRefresh = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.toHeight,
          title: Text('Headlines'),
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
                  'see intrest over time',
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SearchBar(
              textController: textController,
              onPressed: () {
                newsBloc.add(FetchHeadlinesEvent(textController.text));
              },
            ),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                cubit: newsBloc,
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
                                height: 100.toHeight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      state.data.articles[index].urlToImage,
                                      width: 100.toWidth,
                                      height: 100.toHeight,
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
                          fontSize: 28,
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
                          fontSize: 28,
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
