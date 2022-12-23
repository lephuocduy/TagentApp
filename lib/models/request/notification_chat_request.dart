import 'dart:convert';

import 'package:it_job_mobile/models/entity/notification_chat.dart';
import 'package:it_job_mobile/models/entity/notification_status_chat.dart';

class NotificationChatRequest {
  const NotificationChatRequest({
    required this.priority,
    required this.data,
    required this.notification,
    required this.to,
  });

  final String priority;
  final NotificationStatusChat data;
  final NotificationChat notification;
  final String to;

  factory NotificationChatRequest.fromJson(Map<String, dynamic> json) =>
      NotificationChatRequest(
        priority: json["priority"],
        data: NotificationStatusChat.fromJson(json["data"]),
        notification: NotificationChat.fromJson(json["notification"]),
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "priority": priority,
        "data": data.toJson(),
        "notification": notification.toJson(),
        "to": to,
      };

  static NotificationChatRequest notificationChatRequestFromJson(String str) =>
      NotificationChatRequest.fromJson(json.decode(str));

  String notificationChatRequestToJson(NotificationChatRequest data) =>
      json.encode(data.toJson());
}
