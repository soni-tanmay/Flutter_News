import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class NewsApiClient {
  final http.Client httpClient;

  NewsApiClient({@required this.httpClient}) : assert(httpClient != null);
}
