class LikeJobPostLikedRequest {
  LikeJobPostLikedRequest({
    required this.jobPostId,
    required this.profileApplicantId,
  });

  String jobPostId;
  String profileApplicantId;

  factory LikeJobPostLikedRequest.fromJson(Map<String, dynamic> json) =>
      LikeJobPostLikedRequest(
        jobPostId: json["job_post_id"],
        profileApplicantId: json["profile_applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "job_post_id": jobPostId,
        "profile_applicant_id": profileApplicantId,
      };
}
