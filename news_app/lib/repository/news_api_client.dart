import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/utils/config.dart';

class NewsApiClient {
  final http.Client httpClient;

  NewsApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<News> fetchHeadlines(String topic) async {
    final newsHeadlinesUrl =
        '${Config.BASE_URL}/top-headlines?q=$topic&pageSize=${Config.PAGE_SIZE}&apiKey=${Config.API_KEY}';
    final newsHeadlinesResponse = await this.httpClient.get(newsHeadlinesUrl);

    if (newsHeadlinesResponse.statusCode != 200) {
      throw Exception('error fetching headlines');
    }

    final newsHeadlinesJson = jsonDecode(newsHeadlinesResponse.body);
    return News.fromJson(newsHeadlinesJson);
  }

  Future<News> fetchIntrests(String topic) async {
    final newsIntrestsUrl =
        '${Config.BASE_URL}/everything?q=$topic&apiKey=${Config.API_KEY}';
    final newsIntrestsResponse = await this.httpClient.get(newsIntrestsUrl);

    if (newsIntrestsResponse.statusCode != 200) {
      throw Exception('error fetching intrests');
    }

    final newsIntrestsJson = jsonDecode(newsIntrestsResponse.body);
    return News.fromJson(newsIntrestsJson);
  }
}
