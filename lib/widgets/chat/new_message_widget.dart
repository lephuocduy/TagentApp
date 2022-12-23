import 'package:flutter/material.dart';

import '../../constants/toast.dart';
import '../../providers/firebase_provider.dart';

class NewMessageWidget extends StatefulWidget {
  final String name;
  final String id;
  final String chatId;

  const NewMessageWidget({
    required this.name,
    required this.id,
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);

  void sendMessage() {
    FocusScope.of(context).unfocus();

    FirebaseProvider.getAllowChat(context, widget.chatId).then((value) => {
          if (value!.allow)
            {
              FirebaseProvider.uploadMessage(
                context,
                widget.id,
                widget.chatId,
                message,
                '',
                false,
              ),
              FirebaseProvider.getTokenChatUser(context, widget.id)
                  .then((value) => {
                        FirebaseProvider.postNotification(
                          value!.token!,
                          message,
                          widget.name + " đã gửi tin nhắn cho bạn:",
                        ),
                      }),
            }
          else
            {
              showToastFail("Bạn chưa thể gửi tin nhắn"),
            }
        });

    _controller.text = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Nhập tin nhắn',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: message.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
