import 'package:intl/intl.dart';

class WorkingExperience {
   WorkingExperience({
    required this.id,
    required this.profileApplicantId,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.jobPositionId,
  });

   String id;
   String profileApplicantId;
   String companyName;
   DateTime startDate;
   DateTime endDate;
   String jobPositionId;

  factory WorkingExperience.fromJson(Map<String, dynamic> json) =>
      WorkingExperience(
        id: json["id"],
        profileApplicantId: json["profile_applicant_id"],
        companyName: json["company_name"],
        startDate: DateTime.parse(json["start_date"]).toLocal(),
        endDate: DateTime.parse(json["end_date"]  ?? "1969-01-01" ).toLocal(),
        jobPositionId: json["job_position_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_applicant_id": profileApplicantId,
        "company_name": companyName,
        "start_date": startDate.toIso8601String(),
        "end_date": DateFormat('dd/MM/yyyy')
            .format(endDate).contains('01/01/1969')
            ? null
            : endDate.toIso8601String(),
        "job_position_id": jobPositionId,
      };
}
