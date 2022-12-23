class ShareJobPostRequest {
  ShareJobPostRequest({
    required this.jobPostId,
    required this.createBy,
    required this.receiver,
  });

  final String jobPostId;
  final String createBy;
  final String receiver;

  factory ShareJobPostRequest.fromJson(Map<String, dynamic> json) =>
      ShareJobPostRequest(
        jobPostId: json["job_post_id"],
        createBy: json["create_by"],
        receiver: json["receiver"],
      );

  Map<String, dynamic> toJson() => {
        "job_post_id": jobPostId,
        "create_by": createBy,
        "receiver": receiver,
      };
}
