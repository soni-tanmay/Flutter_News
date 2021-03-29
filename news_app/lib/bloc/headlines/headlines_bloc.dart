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

part 'headlines_event.dart';
part 'headlines_state.dart';

class HeadlinesBloc extends Bloc<HeadlinesEvent, HeadlinesState> {
  NewsRepository newsRepository;
  HiveStore hiveStore;
  String previousTopic;
  String headlinesBoxName = 'headlines';
  bool isConnected = true;

  HeadlinesBloc()
      : super(FetchHeadlinesState.empty(
            "Please search for a headlines in the search bar")) {
    newsRepository =
        NewsRepository(newsApiClient: NewsApiClient(httpClient: http.Client()));
    hiveStore = HiveStore();
  }

  @override
  Stream<HeadlinesState> mapEventToState(HeadlinesEvent event) async* {
    switch (event.runtimeType) {
      case FetchHeadlinesEvent:
        yield* fetchNewsHeadlines(event);
        break;
    }
  }

  Stream<HeadlinesState> fetchNewsHeadlines(FetchHeadlinesEvent event) async* {
    print('fetchNewsHeadlines');
    try {
      if (newsRepository.data == null || previousTopic != event.topic) {
        yield FetchHeadlinesState.loading("");
      }
      var data = await hiveStore.readObjects(headlinesBoxName);
      isConnected = await checkConnection();
      if (isConnected) {
        await newsRepository.getHeadlines(event.topic);
        if (newsRepository.status == Status.SUCCESS) {
          previousTopic = event.topic;
          if (newsRepository.data.totalResults != 0) {
            if (data.first != null && data.first.isNotEmpty) {
              hiveStore.updateObjects(
                  headlinesBoxName, newsRepository.data.toJson());
            } else {
              hiveStore.insertObjects(
                  headlinesBoxName, newsRepository.data.toJson());
            }
            yield FetchHeadlinesState.success(newsRepository.data);
          } else {
            yield FetchHeadlinesState.empty('No results found.');
          }
        } else {
          yield FetchHeadlinesState.error(
              "Something went wrong, Please try again !");
        }
      } else {
        if (data.first != null && data.first.isNotEmpty) {
          News news = News.fromJson(data.first);
          yield FetchHeadlinesState.success(news);
        } else {
          yield FetchHeadlinesState.error("No Internet Connection");
        }
      }
    } catch (error) {
      yield FetchHeadlinesState.error("error: $error");
    }
  }
}
