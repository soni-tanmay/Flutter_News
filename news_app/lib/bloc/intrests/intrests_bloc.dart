import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/common_components/bloc_states.dart';
import 'package:news_app/services/check_connection.dart';
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/repository/news_api_client.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/services/hive_db/hive_store.dart';
import 'package:news_app/utils/enums.dart';

part 'intrests_event.dart';
part 'intrests_state.dart';

class IntrestsBloc extends Bloc<IntrestsEvent, IntrestsState> {
  NewsRepository newsRepository;
  HiveStore hiveStore;
  String previousTopic;
  String intrestsBoxName = 'intrests';
  bool isConnected = true;

  IntrestsBloc()
      : super(FetchIntrestsState.empty(
            "Please search for a intrests in the search bar")) {
    newsRepository =
        NewsRepository(newsApiClient: NewsApiClient(httpClient: http.Client()));
    hiveStore = HiveStore();
  }

  @override
  Stream<IntrestsState> mapEventToState(IntrestsEvent event) async* {
    switch (event.runtimeType) {
      case FetchIntrestsEvent:
        yield* fetchNewsIntrests(event);
        break;
    }
  }

  Stream<IntrestsState> fetchNewsIntrests(FetchIntrestsEvent event) async* {
    try {
      yield FetchIntrestsState.loading("");
      var data = await hiveStore.readObjects(intrestsBoxName);
      isConnected = await checkConnection();
      if (isConnected) {
        await newsRepository.getIntrests(event.topic);
        if (newsRepository.status == Status.SUCCESS) {
          previousTopic = event.topic;
          if (newsRepository.data.totalResults != 0) {
            if (data.first != null && data.first.isNotEmpty) {
              hiveStore.updateObjects(
                  intrestsBoxName, newsRepository.data.toJson());
            } else {
              hiveStore.insertObjects(
                  intrestsBoxName, newsRepository.data.toJson());
            }
            yield FetchIntrestsState.success(newsRepository.data);
          } else {
            yield FetchIntrestsState.empty('No results found.');
          }
        } else {
          yield FetchIntrestsState.error(
              "Something went wrong, Please try again !");
        }
      } else {
        if (data.first != null && data.first.isNotEmpty) {
          News news = News.fromJson(data.first);
          yield FetchIntrestsState.success(news);
        } else {
          yield FetchIntrestsState.error("No Internet Connection");
        }
      }
    } catch (error) {
      yield FetchIntrestsState.error("error: $error");
    }
  }
}
