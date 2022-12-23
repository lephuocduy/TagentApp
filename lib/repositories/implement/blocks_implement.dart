import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/block_response.dart';

import 'package:it_job_mobile/models/response/blocks_response.dart';

import '../../models/entity/paging.dart';
import '../../models/request/block_request.dart';
import '../interface/blocks_interface.dart';

class BlocksImplement implements BlocksInterface {
  @override
  Future<BlockResponse> block(
      String url, BlockRequest request, String accessToken) async {
    var result = BlockResponse();
    try {
      Response response = await Dio().post(url,
          data: request.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = BlockResponse.blockResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error block: $e');
    }
    return result;
  }

  @override
  Future<BlocksResponse> getBlockedList(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?applicantId=" + id);
      if (response.statusCode == 200) {
        result =
            BlocksResponse.blocksResponseFromJson(jsonEncode(response.data));
      } else {
        result = BlocksResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getBlockedList: $e');
      result = BlocksResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<String> unBlock(String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error unBlock: $e');
    }
    return result;
  }
}
