part of 'news_bloc.dart';

abstract class NewsEvent {
  const NewsEvent();
}

class FetchHeadlinesEvent extends NewsEvent {
  String topic;
  FetchHeadlinesEvent(this.topic);
}
