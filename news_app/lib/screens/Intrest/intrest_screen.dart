import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/intrests/intrests_bloc.dart';
import 'package:news_app/common_components/search_bar.dart';
import 'package:news_app/services/sizeconfig.dart';
import 'package:news_app/utils/enums.dart';
import 'package:shimmer/shimmer.dart';

class IntrestScreen extends StatefulWidget {
  String searchText;
  IntrestScreen({this.searchText});
  @override
  _IntrestScreenState createState() => _IntrestScreenState();
}

class _IntrestScreenState extends State<IntrestScreen> {
  TextEditingController textController;
  IntrestsBloc intrestsBloc = IntrestsBloc();
  bool isConnected = true;

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
      });
    });
    textController = TextEditingController(
      text: widget.searchText,
    );
    if (widget.searchText.isNotEmpty) {
      intrestsBloc.add(FetchIntrestsEvent(widget.searchText));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map graphData = {
      'sun': 0,
      'mon': 0,
      'tue': 0,
      'wed': 0,
      'thu': 0,
      'fri': 0,
      'sat': 0,
    };
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.toHeight,
          title: Text('Intrests'),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                onTap: () {
                  Navigator.of(context).pop(widget.searchText);
                },
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            BlocListener(
              cubit: intrestsBloc,
              listener: (context, state) {
                if (state is FetchIntrestsState) {
                  setState(() {
                    isConnected = intrestsBloc.isConnected;
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
                        'Connection Lost !\n Displaying Last Fetched Intrests.',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            SearchBar(
              textController: textController,
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  widget.searchText = textController.text;
                  intrestsBloc.add(FetchIntrestsEvent(widget.searchText));
                }
              },
            ),
            Expanded(
                child: BlocBuilder<IntrestsBloc, IntrestsState>(
              cubit: intrestsBloc,
              builder: (context, state) {
                if (state.status == Status.SUCCESS) {
                  state.data.articles.forEach((element) {
                    DateTime date = DateTime.parse(element.publishedAt);
                    switch (date.weekday) {
                      case 1:
                        graphData['mon']++;
                        break;
                      case 2:
                        graphData['tue']++;
                        break;
                      case 3:
                        graphData['wed']++;
                        break;
                      case 4:
                        graphData['thu']++;
                        break;
                      case 5:
                        graphData['fri']++;
                        break;
                      case 6:
                        graphData['sat']++;
                        break;
                      case 7:
                        graphData['sun']++;
                        break;
                    }
                  });
                  return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20.toWidth,
                        20.toHeight,
                        20.toWidth,
                        80.toHeight,
                      ),
                      child: BarChart(BarChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (v) {
                                return graphData.keys
                                    .toList()[v.toInt() - 1]
                                    .toString();
                              }),
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,
                          verticalInterval: 1,
                        ),
                        barGroups: [
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                y: graphData['sun'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                                y: graphData['mon'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                                y: graphData['tue'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(
                                y: graphData['wed'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(
                                y: graphData['thu'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(
                                y: graphData['fri'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(
                                y: graphData['sat'].toDouble(),
                                width: 15.toWidth,
                                colors: [Colors.amber]),
                          ]),
                        ],
                      )),
                    ),
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
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[700],
                    highlightColor: Colors.grey[100],
                    child: Card(
                      color: Colors.white,
                      child: Container(),
                    ),
                  );
                }
              },
            )),
          ],
        ));
  }
}
