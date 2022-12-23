import 'package:it_job_mobile/models/entity/working_experience.dart';
import 'package:it_job_mobile/models/request/working_experience_request.dart';
import 'package:it_job_mobile/models/response/working_experience_response.dart';
import 'package:it_job_mobile/models/response/working_experiences_response.dart';

abstract class WorkingExperiencesInterface {
  Future<WorkingExperiencesResponse> getWorkingExperiencesById(
      String url, String id);
  Future<WorkingExperienceResponse> postWorkingExperience(
      String url, WorkingExperienceRequest request, String accessToken);
  Future<WorkingExperienceResponse> putWorkingExperienceById(
      String url, String id, WorkingExperience request, String accessToken);
  Future<String> deleteWorkingExperienceById(
      String url, String id, String accessToken);
}
