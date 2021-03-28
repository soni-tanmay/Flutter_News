import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/common_components/bloc_states.dart';
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/repository/news_api_client.dart';
import 'package:news_app/repository/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsRepository newsRepository;
  NewsBloc() : super(null) {
    newsRepository =
        NewsRepository(newsApiClient: NewsApiClient(httpClient: http.Client()));
  }

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    switch (event.runtimeType) {
    }
  }
}
