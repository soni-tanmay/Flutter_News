import 'package:news_app/common_components/generic_data_provider.dart';
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/repository/news_api_client.dart';

abstract class AbstractNewsRepository extends GenericDataProvider<News> {}

class NewsRepository extends AbstractNewsRepository {
  final NewsApiClient newsApiClient;
  NewsRepository({this.newsApiClient}) : assert(newsApiClient != null);
}
