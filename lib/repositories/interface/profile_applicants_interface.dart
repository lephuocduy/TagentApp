import 'package:it_job_mobile/models/entity/profile_applicant.dart';
import 'package:it_job_mobile/models/request/profile_applicant_request.dart';
import 'package:it_job_mobile/models/response/check_dislike_response.dart';
import 'package:it_job_mobile/models/response/profile_applicant_response.dart';

import '../../models/response/profile_applicants_response.dart';

abstract class ProfileApplicantsInterface {
  Future<ProfileApplicantResponse> postProfileApplicant(
      String url, ProfileApplicantRequest request, String accessToken);
  Future<ProfileApplicantResponse> putProfileApplicant(
      String url, String id, ProfileApplicant request, String accessToken);
  Future<ProfileApplicantResponse> getProfileApplicantById(
      String url, String id);
  Future<ProfileApplicantsResponse> getProfileApplicantsById(
      String url, String id);
  Future<String> deleteProfileApplicantById(String url, String id, String accessToken);
  Future<CheckDislikeResponse> checkDisLike(String url, String id);
}
