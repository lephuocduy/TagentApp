class JobPost {
  JobPost({
    required this.id,
    required this.title,
    required this.createDate,
    required this.description,
    required this.quantity,
    required this.status,
    required this.companyId,
    required this.jobPositionId,
    required this.workingStyleId,
    required this.workingPlace,
    required this.startTime,
    required this.endTime,
  });

  String id;
  String title;
  DateTime createDate;
  String description;
  int quantity;
  int status;
  String companyId;
  String jobPositionId;
  String workingStyleId;
  String workingPlace;
  DateTime startTime;
  DateTime endTime;

  factory JobPost.fromJson(Map<String, dynamic> json) => JobPost(
        id: json["id"],
        title: json["title"],
        createDate: DateTime.parse(json["create_date"]),
        description: json["description"],
        quantity: json["quantity"],
        status: json["status"],
        companyId: json["company_id"],
        jobPositionId: json["job_position_id"],
        workingStyleId: json["working_style_id"],
        workingPlace: json["working_place"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "create_date": createDate.toIso8601String(),
        "description": description,
        "quantity": quantity,
        "status": status,
        "company_id": companyId,
        "job_position_id": jobPositionId,
        "working_style_id": workingStyleId,
        "working_place": workingPlace,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}
