import 'dart:io';

class StoreImage {
  StoreImage({
    required this.id,
    required this.urlImage,
    this.profileApplicantId,
    this.jobPostId,
    this.applicantId,
    this.image,
  });

  String id;
  String urlImage;
  String? profileApplicantId;
  String? jobPostId;
  String? applicantId;
  File? image;

  StoreImage copy({
    String? id,
    String? urlImage,
  }) =>
      StoreImage(
        id: id ?? this.id,
        urlImage: urlImage ?? this.urlImage,
      );

  factory StoreImage.fromJson(Map<String, dynamic> json) => StoreImage(
        id: json["id"],
        urlImage: json["url_image"],
        profileApplicantId: json["profile_applicant_id"],
        jobPostId: json["job_post_id"],
        applicantId: json["applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url_image": urlImage,
        "profile_applicant_id": profileApplicantId,
        "job_post_id": jobPostId,
        "applicant_id": applicantId,
      };
}
