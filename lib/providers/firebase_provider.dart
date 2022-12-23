import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/models/entity/allow_chat.dart';
import 'package:it_job_mobile/models/entity/applicant.dart';
import 'package:it_job_mobile/models/entity/notification_chat.dart';
import 'package:it_job_mobile/models/entity/notification_status_chat.dart';
import 'package:it_job_mobile/models/entity/user.dart';
import 'package:it_job_mobile/models/request/notification_chat_request.dart';
import 'package:it_job_mobile/models/response/token_chat_response.dart';
import 'package:it_job_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants/toast.dart';
import '../models/entity/message.dart';
import '../utils/utils_firebase.dart';

class FirebaseProvider {
  static Stream<List<User>> getUsers(String id) => FirebaseFirestore.instance
      .collection('users/$id/user')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(UtilsFirebase.transformer(User.fromJson));

  static Future<AllowChat?> getAllowChat(
      BuildContext context, String chatId) async {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    String myId = applicantProvider.applicant.id;
    final refAllowChat =
        FirebaseFirestore.instance.collection('chats/$myId/chat').doc(chatId);
    final snapshot = await refAllowChat.get();
    if (snapshot.exists) {
      return AllowChat.fromJson(snapshot.data()!);
    }
  }

  static Future uploadAllowChat(
      BuildContext context, String idUser, String chatId) async {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    String myId = applicantProvider.applicant.id;
    final refAllowChat1 =
        FirebaseFirestore.instance.collection('chats/$myId/chat').doc(chatId);
    final refAllowChat2 =
        FirebaseFirestore.instance.collection('chats/$idUser/chat').doc(chatId);

    await refAllowChat1.update({
      'allow': true,
      'statusMessage': true,
    });
    await refAllowChat2.update({
      'allow': true,
      'statusMessage': true,
    });

    final refMessages1 = FirebaseFirestore.instance
        .collection('chats/$myId/chat/$chatId/messages');
    final refMessages2 = FirebaseFirestore.instance
        .collection('chats/$idUser/chat/$chatId/messages');

    final newMessage1 = Message(
      applicantId: "",
      urlImage: "",
      name: "admin",
      message: "Từ giờ bạn có thể trò chuyện",
      isJobPost: false,
      createdAt: DateTime.now(),
    );

    final newMessage2 = Message(
      applicantId: "",
      urlImage: "",
      name: "admin",
      message: "Bạn đã được cho phép, từ giờ bạn có thể trò chuyện",
      isJobPost: false,
      createdAt: DateTime.now(),
    );

    await refMessages1.add(newMessage1.toJson());
    await refMessages2.add(newMessage2.toJson());
  }

  static Future uploadMessage(
    BuildContext context,
    String idUser,
    String chatId,
    String message,
    String messageId,
    bool isJobPost,
  ) async {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    String myId = applicantProvider.applicant.id;

    var refMessages1;
    var refMessages2;
    if (isJobPost) {
      refMessages1 = FirebaseFirestore.instance
          .collection('chats/$myId/chat/$chatId/messages')
          .doc(messageId);
      refMessages2 = FirebaseFirestore.instance
          .collection('chats/$idUser/chat/$chatId/messages')
          .doc(messageId);
    } else {
      refMessages1 = FirebaseFirestore.instance
          .collection('chats/$myId/chat/$chatId/messages');
      refMessages2 = FirebaseFirestore.instance
          .collection('chats/$idUser/chat/$chatId/messages');
    }

    final newMessage = Message(
      applicantId: applicantProvider.applicant.id,
      urlImage: applicantProvider.applicant.avatar,
      name: applicantProvider.applicant.name,
      message: message,
      isJobPost: isJobPost,
      createdAt: DateTime.now(),
    );

    if (isJobPost) {
      await refMessages1.set(newMessage.toJson());
      await refMessages2.set(newMessage.toJson());
    } else {
      await refMessages1.add(newMessage.toJson());
      await refMessages2.add(newMessage.toJson());
    }

    final refUser1 =
        FirebaseFirestore.instance.collection('users/$myId/user').doc(idUser);
    final refUser2 =
        FirebaseFirestore.instance.collection('users/$idUser/user').doc(myId);

    String formatISOTime(DateTime date) {
      var duration = date.timeZoneOffset;
      if (duration.isNegative)
        return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
            "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
      else
        return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
            "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }

    DateTime getCurrentTimestamp = DateTime.now();
    String agreementSigned = formatISOTime(getCurrentTimestamp);

    await refUser1.update({
      'lastMessage': message,
      'lastMessageId': myId,
      'lastMessageTime': agreementSigned,
      'lastMessageIsJobPost': isJobPost,
      'statusMessage': true,
    });
    await refUser2.update({
      'lastMessage': message,
      'lastMessageId': myId,
      'lastMessageTime': agreementSigned,
      'lastMessageIsJobPost': isJobPost,
      'statusMessage': true,
    });
  }

  static Stream<List<Message>> getMessages(String myId, String chatId) =>
      FirebaseFirestore.instance
          .collection('chats/$myId/chat/$chatId/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(UtilsFirebase.transformer(Message.fromJson));

  static Future addFriendChat(Applicant my, Applicant user) async {
    var uuid = Uuid();
    String chatId = uuid.v1();
    final refUser1 = FirebaseFirestore.instance
        .collection('users/${my.id}/user')
        .doc(user.id);
    final refUser2 = FirebaseFirestore.instance
        .collection('users/${user.id}/user')
        .doc(my.id);

    final newUser1 = User(
      id: user.id,
      chatId: chatId,
      name: user.name,
      urlImage: user.avatar,
      lastMessage: "",
      lastMessageId: "",
      lastMessageTime: DateTime.now(),
      lastMessageIsJobPost: false,
      statusMessage: false,
    );
    final newUser2 = User(
      id: my.id,
      chatId: chatId,
      name: my.name,
      urlImage: my.avatar,
      lastMessage: "",
      lastMessageId: "",
      lastMessageTime: DateTime.now(),
      lastMessageIsJobPost: false,
      statusMessage: false,
    );

    await refUser1.set(newUser1.toJson());
    await refUser2.set(newUser2.toJson());

    final refMessages1 = FirebaseFirestore.instance
        .collection('chats/${my.id}/chat')
        .doc(chatId);
    final refMessages2 = FirebaseFirestore.instance
        .collection('chats/${user.id}/chat')
        .doc(chatId);

    await refMessages1.set({
      'allow': false,
      'chatById': my.id,
      'statusMessage': false,
    });
    await refMessages2.set({
      'allow': false,
      'chatById': my.id,
      'statusMessage': false,
    });
  }

  static Future deleteMessages(BuildContext context, String myId, String idUser,
      String chatId, DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.endToStart:
        var collection = FirebaseFirestore.instance
            .collection('chats/$myId/chat/$chatId/messages');
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }

        final refUser = FirebaseFirestore.instance
            .collection('users/$myId/user')
            .doc(idUser);

        await refUser.update({
          'statusMessage': false,
        });

        showToastSuccess("Xoá tin nhắn thành công");
        break;
      default:
        break;
    }
  }

  static Future deleteFriend(
      BuildContext context, User user, String chatId) async {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    String myId = applicantProvider.applicant.id;
    String idUser = user.id!;
    final refUser1 =
        FirebaseFirestore.instance.collection('users/$myId/user').doc(idUser);
    final refUser2 =
        FirebaseFirestore.instance.collection('users/$idUser/user').doc(myId);

    await refUser1.delete();

    final checkRefUser2 = await refUser2.get();
    if (checkRefUser2.exists) {
      await refUser2.update({
        'lastMessage': '',
      });
    }
    
    var collection1 = FirebaseFirestore.instance
        .collection('chats/$myId/chat/$chatId/messages');
    var collection2 = FirebaseFirestore.instance
        .collection('chats/$idUser/chat/$chatId/messages');

    var snapshots1 = await collection1.get();
    for (var doc in snapshots1.docs) {
      await doc.reference.delete();
    }

    var snapshots2 = await collection2.get();
    for (var doc in snapshots2.docs) {
      await doc.reference.delete();
    }

    final refAllowChat1 =
        FirebaseFirestore.instance.collection('chats/$myId/chat').doc(chatId);
    final refAllowChat2 =
        FirebaseFirestore.instance.collection('chats/$idUser/chat').doc(chatId);

    await refAllowChat1.delete();
    final checkRefAllowChat2 = await refAllowChat2.get();
    if (checkRefAllowChat2.exists) {
      await refAllowChat2.update({
        'allow': false,
        'chatById': idUser,
      });
    }

    showToastSuccess("Xoá bạn bè thành công");
  }

  static Future<String> postNotification(
      String token, String body, String title) async {
    var result;
    try {
      NotificationChatRequest request = NotificationChatRequest(
          priority: 'high',
          data: NotificationStatusChat(
              clickAction: 'FLUTTER_NOTIFICATION_CLICK',
              status: 'done',
              body: body,
              title: title),
          notification: NotificationChat(
            title: title,
            body: body,
            androidChannelId: 'tagent',
          ),
          to: token);
      Response response =
          await Dio().post('https://fcm.googleapis.com/fcm/send',
              data: request.toJson(),
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAALw0PsWQ:APA91bHJ2VlIsTby36Ug4fnrnOoGk31l0zT59GkS5FXQk5GUJ-z9ANe0k_fQF42bM_aPnLLDXnxDIqBZVocIC0vxzNTV3ugvGyyTc6w1b_SB7KNOtYHKvn2yNJRFYFM4stebd2LzRdZq'
              }));
      result = 'Successful';
    } on DioError catch (e) {
      result = 'Fail';
    }
    return result;
  }

  static Future<TokenChatResponse?> getTokenChatUser(
      BuildContext context, String idUser) async {
    final refTokenChat =
        FirebaseFirestore.instance.collection('userTokens').doc(idUser);
    final snapshot = await refTokenChat.get();
    if (snapshot.exists) {
      return TokenChatResponse.tokenChatResponseFromJson(
          jsonEncode(snapshot.data()));
    }
  }
}
