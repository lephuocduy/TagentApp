import 'package:it_job_mobile/models/entity/store_image.dart';

import 'job_post_skill.dart';

class Liked {
  Liked({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
    required this.companyId,
    required this.jobPositionId,
    required this.workingStyleId,
    required this.workingPlace,
    required this.albumImages,
    required this.jobPostSkills,
  });

  String id;
  String title;
  String description;
  int quantity;
  String companyId;
  String jobPositionId;
  String workingStyleId;
  String workingPlace;
  List<StoreImage> albumImages;
  List<JobPostSkill> jobPostSkills;

  factory Liked.fromJson(Map<String, dynamic> json) => Liked(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        quantity: json["quantity"],
        companyId: json["company_id"],
        jobPositionId: json["job_position_id"],
        workingStyleId: json["working_style_id"],
        workingPlace: json["working_place"],
        albumImages: List<StoreImage>.from(
            json["album_images"].map((x) => StoreImage.fromJson(x))),
        jobPostSkills: List<JobPostSkill>.from(
            json["job_post_skills"].map((x) => JobPostSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "quantity": quantity,
        "company_id": companyId,
        "job_position_id": jobPositionId,
        "working_style_id": workingStyleId,
        "working_place": workingPlace,
        "album_images": List<dynamic>.from(albumImages.map((x) => x.toJson())),
        "job_post_skills":
            List<dynamic>.from(jobPostSkills.map((x) => x.toJson())),
      };
}
