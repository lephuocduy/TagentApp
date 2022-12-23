class Block {
  Block({
    required this.id,
    required this.companyId,
    required this.applicantId,
    required this.blockBy,
  });

  String id;
  String companyId;
  String applicantId;
  String blockBy;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        id: json["id"],
        companyId: json["company_id"],
        applicantId: json["applicant_id"],
        blockBy: json["block_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "applicant_id": applicantId,
        "block_by": blockBy,
      };
}
