class JobPosition {
  JobPosition({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory JobPosition.fromJson(Map<String, dynamic> json) => JobPosition(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
