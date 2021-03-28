import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/common_components/bloc_states.dart';
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/repository/news_api_client.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/utils/enums.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsRepository newsRepository;
  NewsBloc()
      : super(FetchHeadlinesState.empty(
            "Please search for a news in the search bar")) {
    newsRepository =
        NewsRepository(newsApiClient: NewsApiClient(httpClient: http.Client()));
  }

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    switch (event.runtimeType) {
      case FetchHeadlinesEvent:
        yield* fetchNewsHeadlines(event);
        break;
    }
  }

  Stream<NewsState> fetchNewsHeadlines(FetchHeadlinesEvent event) async* {
    try {
      yield FetchHeadlinesState.loading("");
      await newsRepository.getHeadlines(event.topic);
      if (newsRepository.status == Status.SUCCESS) {
        if (newsRepository.data.totalResults != 0) {
          yield FetchHeadlinesState.success(newsRepository.data);
        } else {
          yield FetchHeadlinesState.empty('No results found.');
        }
      } else
        yield FetchHeadlinesState.error(
            "Something went wrong, Please try again !");
    } catch (error) {
      yield FetchHeadlinesState.error("error: $error");
    }
  }
}
