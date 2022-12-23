import 'package:intl/intl.dart';

class Project {
  Project({
    required this.id,
    required this.name,
    required this.link,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.skill,
    required this.jobPosition,
    required this.profileApplicantId,
  });

  String id;
  String name;
  String link;
  String description;
  DateTime startTime;
  DateTime endTime;
  String skill;
  String jobPosition;
  String profileApplicantId;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        link: json["link"],
        description: json["description"],
        startTime: DateTime.parse(json["start_time"]).toLocal(),
        endTime: DateTime.parse(json["end_time"] ?? "1969-01-01").toLocal(),
        skill: json["skill"],
        jobPosition: json["job_position"],
        profileApplicantId: json["profile_applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
        "description": description,
        "start_time": startTime.toIso8601String(),
        "end_time": DateFormat('dd/MM/yyyy')
            .format(endTime).contains('01/01/1969')
            ? null
            : endTime.toIso8601String(),
        "skill": skill,
        "job_position": jobPosition,
        "profile_applicant_id": profileApplicantId,
      };
}
