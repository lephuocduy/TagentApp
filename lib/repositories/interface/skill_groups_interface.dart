import 'package:it_job_mobile/models/response/skill_groups_response.dart';

abstract class SkillGroupsInterface {
  Future<SkillGroupsResponse> getSkillGroups(String url);
}