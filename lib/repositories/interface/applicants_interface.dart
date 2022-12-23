import 'dart:io';

import 'package:it_job_mobile/models/request/enable_to_earn_request.dart';
import 'package:it_job_mobile/models/response/applicants_response.dart';

import '../../models/entity/applicant.dart';
import '../../models/response/applicant_response.dart';

abstract class ApplicantsInterface {
  Future<ApplicantResponse> getApplicantById(String url, String id);
  Future<ApplicantResponse> putApplicantById(
      String url, String id, Applicant request, File avatar, String accessToken);
  Future<String> checkPhone(String url, String phone);
  Future<ApplicantResponse> checkPhoneAddFriend(String url, String phone);
  Future<String> deleteAvatar(String url, String id, String accessToken);
  Future<String> enableToEarn(String url, EnableToEarnRequest request, String accessToken);
  Future<ApplicantsResponse> getListApplicant(String url);
}
