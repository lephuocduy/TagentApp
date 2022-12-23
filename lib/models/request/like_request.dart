class LikeRequest {
  LikeRequest({
    required this.jobPostId,
    required this.profileApplicantId,
    required this.isProfileApplicantLike,
    //required this.isJobPostLike,
  });

  String jobPostId;
  String profileApplicantId;
  bool isProfileApplicantLike;
  //bool isJobPostLike;

  factory LikeRequest.fromJson(Map<String, dynamic> json) => LikeRequest(
        jobPostId: json["job_post_id"],
        profileApplicantId: json["profile_applicant_id"],
        isProfileApplicantLike: json["is_profile_applicant_like"],
        //isJobPostLike: json["is_job_post_like"],
      );

  Map<String, dynamic> toJson() => {
        "job_post_id": jobPostId,
        "profile_applicant_id": profileApplicantId,
        "is_profile_applicant_like": isProfileApplicantLike,
        //"is_job_post_like": isJobPostLike,
      };
}
