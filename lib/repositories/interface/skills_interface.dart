import 'package:it_job_mobile/models/entity/skill.dart';
import 'package:it_job_mobile/models/response/skill_response.dart';
import 'package:it_job_mobile/models/response/skills_response.dart';

abstract class SkillsInterface {
  Future<List<Skill>> searchSkills(List<Skill> listSkill, String query);
  Future<SkillsResponse> getSkills(String url);
  Future<SkillResponse> getSkillById(String url, String id);
}
