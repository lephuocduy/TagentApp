class AllowChat {
  final bool allow;
  final String chatById;
  final bool statusMessage; // display list chat

  const AllowChat({
    required this.allow,
    required this.chatById,
    required this.statusMessage,
  });

  AllowChat copyWith({
    bool? allow,
    String? chatById,
    bool? statusMessage,
  }) =>
      AllowChat(
        allow: allow ?? this.allow,
        chatById: chatById ?? this.chatById,
        statusMessage: statusMessage ?? this.statusMessage,
      );

  static AllowChat fromJson(Map<String, dynamic> json) => AllowChat(
        allow: json['allow'],
        chatById: json['chatById'],
        statusMessage: json['statusMessage'],
      );

  Map<String, dynamic> toJson() => {
        'allow': allow,
        'chatById': chatById,
        'statusMessage': statusMessage,
      };
}
