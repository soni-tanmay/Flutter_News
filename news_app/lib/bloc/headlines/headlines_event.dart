part of 'headlines_bloc.dart';

abstract class HeadlinesEvent {
  const HeadlinesEvent();
}

class FetchHeadlinesEvent extends HeadlinesEvent {
  String topic;
  FetchHeadlinesEvent(this.topic);
}
