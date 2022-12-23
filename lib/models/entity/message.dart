class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String applicantId;
  final String urlImage;
  final String name;
  final String message;
  final bool isJobPost;
  final DateTime createdAt;

  const Message({
    required this.applicantId,
    required this.urlImage,
    required this.name,
    required this.message,
    required this.isJobPost,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        applicantId: json['applicantId'],
        urlImage: json['urlImage'],
        name: json['name'],
        message: json['message'],
        isJobPost: json['isJobPost'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'applicantId': applicantId,
        'urlImage': urlImage,
        'name': name,
        'message': message,
        'isJobPost': isJobPost,
        'createdAt': createdAt.toIso8601String(),
      };
}
