import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/suggest_search_response.dart';

import '../interface/suggest_search_interface.dart';

class SuggestSearchImplement implements SuggestSearchInterface {
  @override
  Future<List<SuggestSearchResponse>> suggestSearch(
      String url, String query) async {
    var result;
    try {
      Response response = await Dio().get(url + "?name=" + query);
      if (response.statusCode == 200) {
        result = SuggestSearchResponse.suggestSearchResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = [];
      }
    } on DioError catch (e) {
      log('Error suggestSearch: $e');
      result = [];
    }
    return result;
  }
}
