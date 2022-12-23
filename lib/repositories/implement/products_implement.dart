import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/request/product_exchange_request.dart';
import 'package:it_job_mobile/models/response/products_response.dart';

import '../../constants/toast.dart';
import '../../models/entity/paging.dart';
import '../interface/products_interface.dart';

class ProductsImplement implements ProductsInterface {
  @override
  Future<ProductsResponse> searchProducts(String url, String query) async {
    var result;
    try {
      Response response = await Dio().get(url + "?name=" + query);
      if (response.statusCode == 200) {
        result = ProductsResponse.productsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ProductsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error searchProducts: $e');
      result = ProductsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<ProductsResponse> getProducts(String url) async {
    var result;
    try {
      Response response = await Dio().get(url + "?status=1");
      if (response.statusCode == 200) {
        result = ProductsResponse.productsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ProductsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getProducts: $e');
      result = ProductsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<String> productExchange(
      String url, ProductExchangeRequest request, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().post(
        url,
        data: request.toJson(),
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'}),
      );
      result = "Successful";
    } on DioError catch (e) {
      log('Error productExchange: $e');
      showToastFail("Số tiền trong ví không đủ để đổi");
    }
    return result;
  }

  @override
  Future<ProductsResponse> getAllProduct(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = ProductsResponse.productsResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = ProductsResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getProducts: $e');
      result = ProductsResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
