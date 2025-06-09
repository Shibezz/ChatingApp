import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(String receiverID, String message) async {
    //get current user info
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    //construct chat room ID for current user and receiverUserID !!VERY IMPORTANT!!
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sorting ensures that the chat room ID is same for any two pair of people
    String chatRoomID = ids.join("_");

    //add message to database
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //Get message from the database
  Stream<QuerySnapshot> getMessages(String userId, String otherUserID) {
    //construct chat room IDs from user ID(Sorted to ensure it matches)
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
