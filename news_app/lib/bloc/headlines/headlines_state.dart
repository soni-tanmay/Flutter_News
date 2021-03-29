part of 'headlines_bloc.dart';

@immutable
abstract class HeadlinesState extends BlocState<News> {
  HeadlinesState.empty(String message) : super.empty(message);
  HeadlinesState.error(String message) : super.error(message);
  HeadlinesState.success(News data) : super.success(data);
  HeadlinesState.loading(String message) : super.loading(message);
}

class FetchHeadlinesState extends HeadlinesState {
  FetchHeadlinesState.success(News data) : super.success(data);
  FetchHeadlinesState.loading(String message) : super.loading(message);
  FetchHeadlinesState.error(String message) : super.error(message);
  FetchHeadlinesState.empty(String message) : super.empty(message);
}
