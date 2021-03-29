import 'package:news_app/utils/enums.dart';

/// Generic class for the API states
abstract class BlocState<T> {
  final Status status;
  final T data;
  final String message;

  const BlocState.loading(this.message, {this.data}) : status = Status.LOADING;

  const BlocState.success(this.data, {this.message}) : status = Status.SUCCESS;

  const BlocState.error(this.message, {this.data}) : status = Status.ERROR;

  const BlocState.empty(this.message, {this.data}) : status = Status.EMPTY;
}
