import 'package:it_job_mobile/models/entity/profile_applicant_skill.dart';
import 'package:it_job_mobile/models/request/profile_applicant_skill_request.dart';
import 'package:it_job_mobile/models/response/profile_applicant_skills_response.dart';

import '../../models/response/profile_applicant_skill_response.dart';

abstract class ProfileApplicantSkillsInterface {
  Future<ProfileApplicantSkillsResponse> getProfileApplicantSkillsById(
      String url, String id);
    Future<ProfileApplicantSkillResponse> postProfileApplicantSkill(
      String url, ProfileApplicantSkillRequest request, String accessToken);
  Future<ProfileApplicantSkillResponse> putProfileApplicantSkillById(
      String url, String id, ProfileApplicantSkill request, String accessToken);
  Future<String> deleteProfileApplicantSkillById(
      String url, String id, String accessToken);
}