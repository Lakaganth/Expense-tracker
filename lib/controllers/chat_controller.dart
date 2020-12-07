import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/controllers/trip_controller.dart';
import 'package:fleming_expense_tracker/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController auth = Get.put(AuthController());
  final TripController trip = Get.put(TripController());

  Rx<ChatUser> chatUser = Rx<ChatUser>();
  Rx<List<ChatUser>> membersList = Rx<List<ChatUser>>();
  Rx<List<UserModel>> usersList = Rx<List<UserModel>>();
  Rx<List<ChatMessage>> messagesList = Rx<List<ChatMessage>>();

  List<ChatMessage> get messages => messagesList.value;

  addMessage(Reply reply) {
    messagesList.value.add(ChatMessage(
        text: reply.value, createdAt: DateTime.now(), user: chatUser.value));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUser();
  }

  void getChatMessages() {
    messagesList.bindStream(chatMessageStream(trip.currentTripId.value));
  }

  void getUser() {
    chatUser.value = ChatUser(
      name: auth.firestoreUser.value.name,
      uid: auth.firestoreUser.value.uid,
      avatar: auth.firestoreUser.value.photoUrl,
      color: Colors.grey,
    );
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    var documentReference = _db
        .collection("trip")
        .doc(trip.currentTripId.value)
        .collection("chat")
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await _db.runTransaction((transaction) async {
      transaction.set(documentReference, message.toJson());
    });
  }

  Stream<List<ChatMessage>> chatMessageStream(String tripId) {
    return _db
        .collection("trip")
        .doc(tripId)
        .collection("chat")
        .snapshots()
        .map((msg) {
      List<ChatMessage> messages = List();
      msg.docs.forEach((m) {
        messages.add(ChatMessage.fromJson(m.data()));
      });

      return messages;
    });
  }
}
