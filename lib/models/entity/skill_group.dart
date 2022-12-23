class SkillGroup {
  SkillGroup({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory SkillGroup.fromJson(Map<String, dynamic> json) => SkillGroup(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
