import 'package:it_job_mobile/models/response/job_post_skills_response.dart';

abstract class JobPostSkillsInterface {
  Future<JobPostSkillsResponse> getJobPostSkillsById(
      String url, String id);
}