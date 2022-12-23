class ProjectRequest {
  const ProjectRequest({
    required this.name,
    required this.link,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.skill,
    required this.jobPosition,
    required this.profileApplicantId,
  });

  final String name;
  final String link;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String skill;
  final String jobPosition;
  final String profileApplicantId;

  factory ProjectRequest.fromJson(Map<String, dynamic> json) => ProjectRequest(
        name: json["name"],
        link: json["link"],
        description: json["description"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        skill: json["skill"],
        jobPosition: json["job_position"],
        profileApplicantId: json["profile_applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
        "description": description,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "skill": skill,
        "job_position": jobPosition,
        "profile_applicant_id": profileApplicantId,
      };
}
