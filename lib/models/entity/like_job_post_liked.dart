class LikeJobPostLiked {
  LikeJobPostLiked({
    required this.id,
    required this.jobPostId,
    required this.profileApplicantId,
    required this.isJobPostLike,
    required this.match,
    required this.matchDate,
  });

  String id;
  String jobPostId;
  String profileApplicantId;
  bool isJobPostLike;
  bool match;
  DateTime matchDate;

  factory LikeJobPostLiked.fromJson(Map<String, dynamic> json) =>
      LikeJobPostLiked(
        id: json["id"],
        jobPostId: json["job_post_id"],
        profileApplicantId: json["profile_applicant_id"],
        isJobPostLike: json["is_job_post_like"],
        match: json["match"] ?? false,
        matchDate: DateTime.parse(json["match_date"] ?? "1969-01-01").toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_post_id": jobPostId,
        "profile_applicant_id": profileApplicantId,
        "is_job_post_like": isJobPostLike,
        "match": match,
        "match_date": matchDate.toIso8601String(),
      };
}
