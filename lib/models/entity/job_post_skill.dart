class JobPostSkill {
  JobPostSkill({
    required this.id,
    required this.jobPostId,
    required this.skillId,
    required this.skillLevel,
  });

  String id;
  String jobPostId;
  String skillId;
  String skillLevel;

  factory JobPostSkill.fromJson(Map<String, dynamic> json) => JobPostSkill(
        id: json["id"],
        jobPostId: json["job_post_id"],
        skillId: json["skill_id"],
        skillLevel: json["skill_level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_post_id": jobPostId,
        "skill_id": skillId,
        "skill_level": skillLevel,
      };
}
