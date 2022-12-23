class NotificationStatusChat {
  NotificationStatusChat({
    required this.clickAction,
    required this.status,
    required this.body,
    required this.title,
  });

  String clickAction;
  String status;
  String body;
  String title;

  factory NotificationStatusChat.fromJson(Map<String, dynamic> json) =>
      NotificationStatusChat(
        clickAction: json["click_action"],
        status: json["status"],
        body: json["body"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "click_action": clickAction,
        "status": status,
        "body": body,
        "title": title,
      };
}
