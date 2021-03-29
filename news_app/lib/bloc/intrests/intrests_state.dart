part of 'intrests_bloc.dart';

@immutable
abstract class IntrestsState extends BlocState<News> {
  IntrestsState.empty(String message) : super.empty(message);
  IntrestsState.error(String message) : super.error(message);
  IntrestsState.success(News data) : super.success(data);
  IntrestsState.loading(String message) : super.loading(message);
}

class FetchIntrestsState extends IntrestsState {
  FetchIntrestsState.success(News data) : super.success(data);
  FetchIntrestsState.loading(String message) : super.loading(message);
  FetchIntrestsState.error(String message) : super.error(message);
  FetchIntrestsState.empty(String message) : super.empty(message);
}
