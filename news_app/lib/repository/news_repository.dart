import 'package:news_app/common_components/generic_data_provider.dart';
import 'package:news_app/repository/models/news_models.dart';
import 'package:news_app/repository/news_api_client.dart';
import 'package:news_app/utils/enums.dart';

abstract class AbstractNewsRepository extends GenericDataProvider<News> {
  getHeadlines(String topic);
}

class NewsRepository extends AbstractNewsRepository {
  final NewsApiClient newsApiClient;
  NewsRepository({this.newsApiClient}) : assert(newsApiClient != null);
  @override
  getHeadlines(String topic) async {
    try {
      status = Status.LOADING;
      data = await newsApiClient.fetchHeadlines(topic);
      status = Status.SUCCESS;
    } catch (error) {
      errorMessage = error.toString();
      status = Status.ERROR;
    }
  }
}
