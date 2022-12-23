class Like {
  Like({
    required this.id,
    required this.jobPostId,
    required this.profileApplicantId,
    required this.isProfileApplicantLike,
    //required this.isJobPostLike,
  });

  String id;
  String jobPostId;
  String profileApplicantId;
  bool isProfileApplicantLike;
  //bool isJobPostLike;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        jobPostId: json["job_post_id"],
        profileApplicantId: json["profile_applicant_id"],
        isProfileApplicantLike: json["is_profile_applicant_like"],
        //isJobPostLike: json["is_job_post_like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_post_id": jobPostId,
        "profile_applicant_id": profileApplicantId,
        "is_profile_applicant_like": isProfileApplicantLike,
        //"is_job_post_like": isJobPostLike,
      };
}
