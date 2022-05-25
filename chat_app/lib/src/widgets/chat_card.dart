// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';
import '../models/chat_user_model.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.chatController,
  }) : super(key: key);

  final ChatMessage chat;
  final ChatController chatController;

  isYOU() {}
  @override
  Widget build(BuildContext context) {
    return Container(

        // width: 300,
        // color: Colors.red,
        alignment: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
            ? Alignment.bottomRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              // mainAxisSize: MainAxisSize.min,

              children: [
                Column(
                  crossAxisAlignment:
                      chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    if (chat.sentBy != FirebaseAuth.instance.currentUser?.uid &&
                        chatController.previousChatID != chat.sentBy)

                      // chatController.previousChatID = chat.sentBy;
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          'chat.sentBy',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      )
                    else
                      Container(),
                    FutureBuilder<ChatUser>(
                        future: ChatUser.fromUid(uid: chat.sentBy),
                        builder: (context, AsyncSnapshot<ChatUser> snap) {
                          if (snap.hasData &&
                              chat.sentBy !=
                                  FirebaseAuth.instance.currentUser?.uid &&
                              chatController.previousChatID != chat.sentBy) {
                            chatController.previousChatID = chat.sentBy;
                            return Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                '${snap.data?.username}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            );
                          }
                          chatController.previousChatID = chat.sentBy;
                          print(
                              '${chatController.previousChatID} and ${chat.sentBy} message: ${chat.message}');
                          return const SizedBox();
                        }),
                    Container(
                      // margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).primaryColor,
                      ),
                      // color: Colors.black,
                      child: Text(
                        chat.message,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    Container(
                      padding:
                          chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                              ? const EdgeInsets.only(right: 10)
                              : const EdgeInsets.only(left: 10),
                      // child: Text(
                      //   "data",
                      //   style: Theme.of(context).textTheme.caption,
                      // ),
                    )
                    // Text('Message seen by ${chat.seenBy}')
                  ],
                ),
              ],
            ),
          ),
        ));
    // );
  }
}
