class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? id;
  final String chatId;
  final String name;
  final String urlImage;
  final String lastMessage;
  final String lastMessageId; // distinguish user
  final DateTime lastMessageTime;
  final bool lastMessageIsJobPost; // distinguish job post
  final bool statusMessage;

  const User({
    this.id,
    required this.chatId,
    required this.name,
    required this.urlImage,
    required this.lastMessage,
    required this.lastMessageId,
    required this.lastMessageTime,
    required this.lastMessageIsJobPost,
    required this.statusMessage,
  });

  User copyWith({
    String? id,
    String? chatId,
    String? name,
    String? urlImage,
    String? lastMessage,
    String? lastMessageId,
    DateTime? lastMessageTime,
    bool? lastMessageIsJobPost,
    bool? statusMessage,
  }) =>
      User(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        name: name ?? this.name,
        urlImage: urlImage ?? this.urlImage,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        lastMessageIsJobPost: lastMessageIsJobPost ?? this.lastMessageIsJobPost,
        statusMessage: statusMessage ?? this.statusMessage,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        chatId: json['chatId'],
        name: json['name'],
        urlImage: json['urlImage'],
        lastMessage: json['lastMessage'],
        lastMessageId: json['lastMessageId'],
        lastMessageTime: DateTime.parse(json['lastMessageTime'] ?? "1969-01-01"),
        lastMessageIsJobPost: json['lastMessageIsJobPost'],
        statusMessage: json['statusMessage'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'name': name,
        'urlImage': urlImage,
        'lastMessage': lastMessage,
        'lastMessageId': lastMessageId,
        'lastMessageTime': lastMessageTime.toIso8601String(),
        'lastMessageIsJobPost': lastMessageIsJobPost,
        'statusMessage': statusMessage,
      };
}
