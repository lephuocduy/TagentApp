import 'package:intl/intl.dart';

class CertificateRequest {
  const CertificateRequest({
    required this.name,
    required this.skillGroupId,
    required this.profileApplicantId,
    required this.grantDate,
    required this.expiryDate,
  });

  final String name;
  final String skillGroupId;
  final String profileApplicantId;
  final DateTime grantDate;
  final DateTime expiryDate;

  factory CertificateRequest.fromJson(Map<String, dynamic> json) =>
      CertificateRequest(
        name: json["name"],
        skillGroupId: json["skill_group_id"],
        profileApplicantId: json["profile_applicant_id"],
        grantDate: DateTime.parse(json["grant_date"]).toLocal(),
        expiryDate:
            DateTime.parse(json["expiry_date"] ?? "1969-01-01").toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "skill_group_id": skillGroupId,
        "profile_applicant_id": profileApplicantId,
        "grant_date": grantDate.toIso8601String(),
        "expiry_date":
            DateFormat('dd/MM/yyyy').format(expiryDate).contains('01/01/1969')
                ? null
                : expiryDate.toIso8601String(),
      };
}
