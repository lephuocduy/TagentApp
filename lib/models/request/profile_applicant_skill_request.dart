class ProfileApplicantSkillRequest {
  const ProfileApplicantSkillRequest({
    required this.profileApplicantId,
    required this.skillId,
    required this.skillLevel,
  });

  final String profileApplicantId;
  final String skillId;
  final String skillLevel;

  factory ProfileApplicantSkillRequest.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantSkillRequest(
        profileApplicantId: json["profile_applicant_id"],
        skillId: json["skill_id"],
        skillLevel: json["skill_level"],
      );

  Map<String, dynamic> toJson() => {
        "profile_applicant_id": profileApplicantId,
        "skill_id": skillId,
        "skill_level": skillLevel,
      };
}
