class ProfileApplicantSkill {
  ProfileApplicantSkill({
    required this.id,
    required this.profileApplicantId,
    required this.skillId,
    required this.skillLevel,
  });

  String id;
  String profileApplicantId;
  String skillId;
  String skillLevel;

  factory ProfileApplicantSkill.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantSkill(
        id: json["id"],
        profileApplicantId: json["profile_applicant_id"],
        skillId: json["skill_id"],
        skillLevel: json["skill_level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_applicant_id": profileApplicantId,
        "skill_id": skillId,
        "skill_level": skillLevel,
      };
}
