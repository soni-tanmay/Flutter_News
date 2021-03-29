part of 'intrests_bloc.dart';

abstract class IntrestsEvent {
  const IntrestsEvent();
}

class FetchIntrestsEvent extends IntrestsEvent {
  String topic;
  FetchIntrestsEvent(this.topic);
}
