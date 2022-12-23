import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/response/certificate_response.dart';
import 'package:it_job_mobile/models/request/certificate_request.dart';
import 'package:it_job_mobile/models/entity/certificate.dart';

import '../../models/entity/paging.dart';
import '../../models/response/certificates_response.dart';
import '../interface/certificates_interface.dart';

class CertificatesImplement implements CertificatesInterface {
  @override
  Future<CertificatesResponse> searchCertificates(
      String url, String query, String skillGroupId) async {
    var result;
    try {
      Response response = await Dio()
          .get(url + "?name=" + query + "&skillGroupId=" + skillGroupId);
      if (response.statusCode == 200) {
        result = CertificatesResponse.certificateResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = CertificatesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error searchCertificates: $e');
      result = CertificatesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<CertificatesResponse> getCertificatesById(
      String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "?profileApplicantId=" + id);
      if (response.statusCode == 200) {
        result = CertificatesResponse.certificateResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = CertificatesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getCertificatesById: $e');
      result = CertificatesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }

  @override
  Future<CertificateResponse> postCertificate(
      String url, CertificateRequest request, String accessToken) async {
    var result = CertificateResponse();
    try {
      Response response = await Dio().post(url,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = CertificateResponse.certificateResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error postCertificate: $e');
    }
    return result;
  }

  @override
  Future<CertificateResponse> putCertificateById(
      String url, String id, Certificate request, String accessToken) async {
    var result = CertificateResponse();
    try {
      Response response = await Dio().put(url + "/" + id,
          data: request,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = CertificateResponse.certificateResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      log('Error putCertificateById: $e');
    }
    return result;
  }

  @override
  Future<String> deleteCertificateById(
      String url, String id, String accessToken) async {
    var result = "Fail";
    try {
      await Dio().delete(url + "/" + id,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      result = "Successful";
    } on DioError catch (e) {
      log('Error deleteCertificateById: $e');
    }
    return result;
  }
}
