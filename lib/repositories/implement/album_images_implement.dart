import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/album_images_response.dart';
import 'package:it_job_mobile/repositories/interface/album_images_interface.dart';

import '../../models/entity/paging.dart';
import '../../models/response/store_image_response.dart';

class AlbumImagesImplement implements AlbumImagesInterface {
  @override
  Future<AlbumImagesResponse> getAlbumImagesById(
      String url, String getBy, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + getBy + id);
      if (response.statusCode == 200) {
        result = AlbumImagesResponse.albumImagesResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = AlbumImagesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getAlbumImagesById: $e');
      result = AlbumImagesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<List<StoreImageResponse>> postAlbumImages(
      String url, String id, File image, String accessToken) async {
    var result;
    try {
      String fileName = image.path.split('/').last;
      var formData = FormData.fromMap({
        "profileApplicantId": id,
        "jobPostId": null,
        "uploadFiles": image.path.isNotEmpty
            ? await MultipartFile.fromFile(image.path, filename: fileName)
            : null,
      });
      Response response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = StoreImageResponse.storeImagesResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postAlbumImages: $e');
    }
    return result;
  }

  @override
  Future<String> deleteAlbumImageById(
      String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteAlbumImageById: $e');
    }
    return result;
  }

  @override
  Future<AlbumImagesResponse> getAlbumImagesByJobPostId(
      String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?jobPostId=" + id);
      if (response.statusCode == 200) {
        result = AlbumImagesResponse.albumImagesResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = AlbumImagesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getAlbumImagesByJobPostId: $e');
      result = AlbumImagesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<String> enableToEarnImageById(
      String url, String id, File image, String accessToken) async {
    var result = "Fail";
    try {
      String fileName = image.path.split('/').last;
      var formData = FormData.fromMap({
        "applicantId": id,
        "uploadFiles":
            await MultipartFile.fromFile(image.path, filename: fileName)
      });
      Response response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error enableToEarnImageById: $e');
    }
    return result;
  }
}
