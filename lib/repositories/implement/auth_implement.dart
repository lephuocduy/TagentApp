import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/entity/applicant.dart';
import 'package:it_job_mobile/models/request/sign_in_request.dart';
import 'package:it_job_mobile/models/request/sign_up_request.dart';
import 'package:it_job_mobile/models/response/sign_in_response.dart';

import '../../constants/toast.dart';
import '../../models/response/applicant_response.dart';
import '../interface/auth_interface.dart';

class AuthImplement implements AuthInterface {
  @override
  Future<SignInResponse> signIn(String url, SignInRequest request) async {
    var result;
    try {
      Response response = await Dio().post(url, data: request.toJson());
      result = SignInResponse.signInResponseFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      if (e.response?.data["detail"] ==
          "Your account not verify, please verify your account and login again!!!") {
        showToastFail("Bạn vui lòng xác thực số điện thoại");
        return result = SignInResponse(token: 'verify');
      }
      if (e.response?.data["detail"].toString().substring(0, 4) == "Your") {
        showToastFail(
            "Tài khoản của bạn đã bị khoá vì lí do \n ${e.response?.data["detail"].toString().substring(32)}");
        return result = SignInResponse(token: '');
      }
      showToastFail("Số điện thoại hoặc mật khẩu không đúng");
      result = SignInResponse(token: '');
    }
    return result;
  }

  @override
  Future<ApplicantResponse> signUp(String url, SignUpRequest request) async {
    var result;
    try {
      var formData = FormData.fromMap({
        "phone": request.phone,
        "password": request.password,
        "email": request.email,
        "name": null,
        "gender": null,
        "dob": null,
        "address": null,
        "uploadFile": null,
      });
      Response response = await Dio().post(url, data: formData);
      result = ApplicantResponse.applicantsResponseFromJson(
          jsonEncode(response.data));
    } on DioError catch (e) {
      showToastFail("Số điện thoại này đã được đăng ký");
      result = ApplicantResponse(
        code: 405,
        msg: '',
        data: Applicant(
          id: '',
          phone: 'exist',
          email: '',
          name: '',
          avatar: '',
          gender: 0,
          dob: DateTime.now(),
          address: '',
          earnMoney: 0,
        ),
      );
    }
    return result;
  }

  @override
  Future<String> getOTP(String url, String phone) async {
    var result = 'Fail';
    try {
      Response response = await Dio().get(url + "/" + phone);
      result = response.data;
    } on DioError catch (e) {
      log('Error getOTP: $e');
      //showToastFail("Số điện thoại không hợp lệ");
    }
    return result;
  }

  @override
  Future<String> verifyOTP(String url, String OTP, String phone) async {
    var result = 'Fail';
    try {
      await Dio().get(url + "?code=" + OTP + "&phone=" + phone);
      result = 'Successful';
    } on DioError catch (e) {
      log('Error verifyOTP: $e');
    }
    return result;
  }

  @override
  Future<String> changePassword(String url, String id, String currentPassword,
      String newPassword, String accessToken) async {
    var result = 'Fail';
    try {
      Response response = await Dio().put(
          url +
              "/password?id=" +
              id +
              "&currentPassword=" +
              currentPassword +
              "&newPassword=" +
              newPassword,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }));
      showToastSuccess("Đổi mật khẩu thành công");
      result = 'Successful';
    } on DioError catch (e) {
      showToastFail("Mật khẩu cũ không đúng");
      log('Error changePassword: $e');
    }
    return result;
  }

  @override
  Future<String> forgotPassword(
      String url, String phone, String OTP, String newPassword) async {
    var result = 'Fail';
    try {
      Response response = await Dio().put(url +
          "/reset?phone=" +
          phone +
          "&otp=" +
          OTP +
          "&newPassword=" +
          newPassword);
      showToastSuccess("Đổi mật khẩu thành công");
      result = 'Successful';
    } on DioError catch (e) {
      showToastFail("Đổi mật khẩu không thành công");
      log('Error forgotPassword: $e');
    }
    return result;
  }
}
