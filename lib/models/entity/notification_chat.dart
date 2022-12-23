class NotificationChat {
  NotificationChat({
    required this.title,
    required this.body,
    required this.androidChannelId,
  });

  String title;
  String body;
  String androidChannelId;

  factory NotificationChat.fromJson(Map<String, dynamic> json) =>
      NotificationChat(
        title: json["title"],
        body: json["body"],
        androidChannelId: json["android_channel_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "android_channel_id": androidChannelId,
      };
}
