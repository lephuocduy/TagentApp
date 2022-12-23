class Skill {
  Skill({
    required this.id,
    required this.name,
    required this.skillGroupId,
  });

  String id;
  String name;
  String skillGroupId;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
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
