class SkillLevel {
  SkillLevel({
    required this.id,
    required this.name,
    required this.skillGroupId,
  });

  String id;
  String name;
  String skillGroupId;

  factory SkillLevel.fromJson(Map<String, dynamic> json) => SkillLevel(
        id: json["id"],
        name: json["name"],
        skillGroupId: json["skill_group_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "skill_group_id": skillGroupId,
      };
}
