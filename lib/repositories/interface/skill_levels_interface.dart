import 'package:it_job_mobile/models/response/skill_levels_response.dart';

abstract class SkillLevelsInterface {
  Future<SkillLevelsResponse> getLevelById(String url, String id);
}
