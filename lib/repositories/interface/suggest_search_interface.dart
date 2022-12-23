import 'package:it_job_mobile/models/response/suggest_search_response.dart';

abstract class SuggestSearchInterface {
  Future<List<SuggestSearchResponse>> suggestSearch(String url, String query);
}
