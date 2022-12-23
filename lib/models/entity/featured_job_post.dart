import 'dart:convert';

import 'package:it_job_mobile/models/entity/job_position.dart';
import 'package:it_job_mobile/models/entity/job_post_skill.dart';
import 'package:it_job_mobile/models/entity/store_image.dart';
import 'package:it_job_mobile/models/entity/working_style.dart';

FeaturedJobPost featuredJobPostFromJson(String str) =>
    FeaturedJobPost.fromJson(json.decode(str));

String featuredJobPostToJson(FeaturedJobPost data) =>
    json.encode(data.toJson());

class FeaturedJobPost {
  FeaturedJobPost({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
    required this.status,
    required this.companyId,
    required this.jobPositionId,
    required this.workingStyleId,
    required this.workingPlace,
    required this.jobPosition,
    required this.workingStyle,
    required this.albumImages,
    required this.jobPostSkills,
  });

  String id;
  String title;
  String description;
  int quantity;
  int status;
  String companyId;
  String jobPositionId;
  String workingStyleId;
  String workingPlace;
  JobPosition jobPosition;
  WorkingStyle workingStyle;
  List<StoreImage> albumImages;
  List<JobPostSkill> jobPostSkills;

  factory FeaturedJobPost.fromJson(Map<String, dynamic> json) =>
      FeaturedJobPost(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        quantity: json["quantity"],
        status: json["status"],
        companyId: json["company_id"],
        jobPositionId: json["job_position_id"],
        workingStyleId: json["working_style_id"],
        workingPlace: json["working_place"],
        jobPosition: json["job_position"] != null
            ? JobPosition.fromJson(json["job_position"])
            : JobPosition(id: "", name: ""),
        workingStyle: json["working_style"] != null
            ? WorkingStyle.fromJson(json["working_style"])
            : WorkingStyle(id: "", name: ""),
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
        "status": status,
        "company_id": companyId,
        "job_position_id": jobPositionId,
        "working_style_id": workingStyleId,
        "working_place": workingPlace,
        "job_position": jobPosition.toJson(),
        "working_style": workingStyle.toJson(),
        "album_images": List<dynamic>.from(albumImages.map((x) => x.toJson())),
        "job_post_skills":
            List<dynamic>.from(jobPostSkills.map((x) => x.toJson())),
      };
}
