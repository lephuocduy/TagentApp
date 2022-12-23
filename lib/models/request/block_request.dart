class BlockRequest {
  BlockRequest({
    required this.companyId,
    required this.applicantId,
    required this.blockBy,
  });

  String companyId;
  String applicantId;
  String blockBy;

  factory BlockRequest.fromJson(Map<String, dynamic> json) => BlockRequest(
        companyId: json["company_id"],
        applicantId: json["applicant_id"],
        blockBy: json["block_by"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "applicant_id": applicantId,
        "block_by": blockBy,
      };
}
