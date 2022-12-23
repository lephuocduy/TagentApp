import 'package:it_job_mobile/models/entity/project.dart';
import 'package:it_job_mobile/models/request/project_request.dart';
import 'package:it_job_mobile/models/response/project_response.dart';
import 'package:it_job_mobile/models/response/projects_response.dart';

abstract class ProjectsInterface {
  Future<ProjectsResponse> getProjectsById(
      String url, String id);
    Future<ProjectResponse> postProject(
      String url, ProjectRequest request, String accessToken);
  Future<ProjectResponse> putProjectById(
      String url, String id, Project request, String accessToken);
  Future<String> deleteProjectById(
      String url, String id, String accessToken);
}