part of 'news_bloc.dart';

@immutable
abstract class NewsState extends BlocState<News> {
  NewsState.empty(String message) : super.empty(message);
  NewsState.error(String message) : super.error(message);
  NewsState.success(News data) : super.success(data);
  NewsState.loading(String message) : super.loading(message);
}
