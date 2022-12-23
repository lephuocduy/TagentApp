class ProfileApplicant {
  ProfileApplicant(
      {required this.id,
      required this.createDate,
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

  final String id;
  final DateTime createDate;
  final String applicantId;
  final String description;
  String education;
  String githubLink;
  String linkedInLink;
  String facebookLink;
  String jobPositionId;
  String workingStyleId;
  final int status;

  factory ProfileApplicant.fromJson(Map<String, dynamic> json) =>
      ProfileApplicant(
        id: json["id"] ?? "",
        createDate: DateTime.parse(json["create_date"]),
        applicantId: json["applicant_id"] ?? "",
        description: json["description"] ?? "",
        education: json["education"] ?? "",
        githubLink: json["github_link"] ?? "",
        linkedInLink: json["linked_in_link"] ?? "",
        facebookLink: json["facebook_link"] ?? "",
        jobPositionId: json["job_position_id"] ?? "",
        workingStyleId: json["working_style_id"] ?? "",
        status: json["status"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_date": createDate.toIso8601String(),
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
