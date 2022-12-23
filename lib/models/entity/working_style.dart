class WorkingStyle {
  WorkingStyle({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory WorkingStyle.fromJson(Map<String, dynamic> json) => WorkingStyle(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
