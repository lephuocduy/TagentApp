class ProfileApplicantRequest {
  const ProfileApplicantRequest({
    required this.applicantId,
    required this.description,
    required this.education,
    required this.githubLink,
    required this.linkedInLink,
    required this.facebookLink,
    required this.jobPositionId,
    required this.workingStyleId,
    required this.status,
  });

  final String applicantId;
  final String description;
  final String education;
  final String githubLink;
  final String linkedInLink;
  final String facebookLink;
  final String jobPositionId;
  final String workingStyleId;
  final int status;

  factory ProfileApplicantRequest.fromJson(Map<String, dynamic> json) =>
      ProfileApplicantRequest(
        applicantId: json["applicant_id"],
        description: json["description"],
        education: json["education"],
        githubLink: json["github_link"],
        linkedInLink: json["linked_in_link"],
        facebookLink: json["facebook_link"],
        jobPositionId: json["job_position_id"],
        workingStyleId: json["working_style_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "applicant_id": applicantId,
        "description": description,
        "education": education,
        "github_link": githubLink,
        "linked_in_link": linkedInLink,
        "facebook_link": facebookLink,
        "job_position_id": jobPositionId,
        "working_style_id": workingStyleId,
        "status": status,
      };
}
