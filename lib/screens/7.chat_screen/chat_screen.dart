import 'package:dash_chat/dash_chat.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  TripController trip = Get.put(TripController());
  ChatController chat = Get.put(ChatController());

  var i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: chat.chatMessageStream(trip.currentTripId.value),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<ChatMessage> messages = snapshot.data;

          if (snapshot.data != null) {
            return DashChat(
              key: _chatViewKey,
              inverted: false,
              onSend: chat.onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: chat.chatUser.value,
              inputDecoration:
                  InputDecoration.collapsed(hintText: "Add message here..."),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: true,
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              alwaysShowSend: true,
              inputTextStyle: TextStyle(fontSize: 16.0),
              // inputContainerStyle: BoxDecoration(
              //   border: Border.all(width: 0.0),
              //   color: Colors.white,
              // ),
              messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                return BoxDecoration(
                  color: isUser ? Colors.purple : Colors.amber,
                  borderRadius: BorderRadius.circular(8.0),
                );
              },
              onLoadEarlier: () {
                print("Loading...");
              },
              shouldShowLoadEarlier: false,
            );
          } else {
            return Center(
              child: Text("Hello"),
            );
          }
        }
      },
    ));
  }
}
