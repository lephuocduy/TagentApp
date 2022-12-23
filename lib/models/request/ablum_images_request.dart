class AblumImagesRequest {
  const AblumImagesRequest({
    required this.urlImage,
    required this.profileApplicantId,
  });

  final String urlImage;
  final String profileApplicantId;

  factory AblumImagesRequest.fromJson(Map<String, dynamic> json) =>
      AblumImagesRequest(
        urlImage: json["url_image"],
        profileApplicantId: json["profile_applicant_id"],
      );

  Map<String, dynamic> toJson() => {
        "url_image": urlImage,
        "profile_applicant_id": profileApplicantId,
      };
}
