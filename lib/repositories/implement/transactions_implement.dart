import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/transaction_reward_exchanges_response.dart';
import 'package:it_job_mobile/models/response/transaction_job_posts_response.dart';
import 'package:it_job_mobile/repositories/interface/transactions_interface.dart';

import '../../models/entity/paging.dart';

class TransactionsImplement implements TransactionsInterface {
  @override
  Future<TransactionJobPostsResponse> getTransactionJobPosts(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?createBy=" + id);
      if (response.statusCode == 200) {
        result =
            TransactionJobPostsResponse.transactionJobPostsResponseFromJson(jsonEncode(response.data));
      } else {
        result = TransactionJobPostsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getTransactionJobPosts: $e');
      result = TransactionJobPostsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<TransactionRewardExchangesResponse> getTransactionRewardExchanges(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?createBy=" + id);
      if (response.statusCode == 200) {
        result =
            TransactionRewardExchangesResponse.transactionRewardExchangesResponseFromJson(jsonEncode(response.data));
      } else {
        result = TransactionRewardExchangesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getTransactionRewardExchanges: $e');
      result = TransactionRewardExchangesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

}