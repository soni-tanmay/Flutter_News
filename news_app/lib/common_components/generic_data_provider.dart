import 'package:news_app/utils/enums.dart';

abstract class GenericDataProvider<T> {
  Status status;
  T data;
  String errorMessage;
}
