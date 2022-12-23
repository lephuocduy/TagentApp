class WorkingExperienceRequest {
  const WorkingExperienceRequest({
    required this.profileApplicantId,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.jobPositionId,
  });

  final profileApplicantId;
  final companyName;
  final DateTime startDate;
  final DateTime endDate;
  final jobPositionId;

  factory WorkingExperienceRequest.fromJson(Map<String, dynamic> json) =>
      WorkingExperienceRequest(
        profileApplicantId: json["profile_applicant_id"],
        companyName: json["company_name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        jobPositionId: json["job_position_id"],
      );

  Map<String, dynamic> toJson() => {
        "profile_applicant_id": profileApplicantId,
        "company_name": companyName,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "job_position_id": jobPositionId,
      };
}
