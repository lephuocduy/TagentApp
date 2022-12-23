import 'package:it_job_mobile/models/entity/featured_job_post.dart';


class Matching {
    Matching({
        required this.id,
        required this.jobPostId,
        required this.profileApplicantId,
        // required this.isProfileApplicantLike,
        // required this.isJobPostLike,
        required this.match,
        required this.matchDate,
        required this.jobPost,
    });

    String id;
    String jobPostId;
    String profileApplicantId;
    // bool isProfileApplicantLike;
    // bool isJobPostLike;
    bool match;
    DateTime matchDate;
    FeaturedJobPost jobPost;

    factory Matching.fromJson(Map<String, dynamic> json) => Matching(
        id: json["id"],
        jobPostId: json["job_post_id"],
        profileApplicantId: json["profile_applicant_id"],
        // isProfileApplicantLike: json["is_profile_applicant_like"],
        // isJobPostLike: json["is_job_post_like"],
        match: json["match"] ?? false,
        matchDate: DateTime.parse(json["match_date"] ?? "1969-01-01"),
        jobPost: FeaturedJobPost.fromJson(json["job_post"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "job_post_id": jobPostId,
        "profile_applicant_id": profileApplicantId,
        // "is_profile_applicant_like": isProfileApplicantLike,
        // "is_job_post_like": isJobPostLike,
        "match": match,
        "match_date": matchDate.toIso8601String(),
        "job_post": jobPost.toJson(),
    };
}
