// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_message_model.dart';

// ignore: must_be_immutable
class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.index,
    required this.chat,
    required this.chatController,
  }) : super(key: key);

  final int index;
  final ChatMessage chat;
  final ChatController chatController;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  var isVisible = false;
  ChatMessage get chat => widget.chat;
  int get index => widget.index;

  // @override
  // Widget build(BuildContext context) {
  //   return Visibility(
  //     child: Container(
  //       child: Text(chat.message),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(

        // width: 300,

        alignment: widget.chat.sentBy == FirebaseAuth.instance.currentUser?.uid
            ? Alignment.bottomRight
            : Alignment.centerLeft,
        // color: Colors.red,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              // Visibility(
              //   visible: isVisible,
              //   child: Container(
              //     color: Colors.red,
              //     alignment: Alignment.center,
              //     width: double.infinity,
              //     // color: Colors.green,
              //     child: Text('date'),
              //   ),
              // ),
              Container(
                // color: Colors.pink,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                alignment:
                    widget.chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   isVisible = !isVisible;
                    // });
                  },
                  child: Container(
                    // color: Colors.amber,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(index.toString()),
                        Column(
                          crossAxisAlignment: widget.chat.sentBy ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (widget.chat.sentBy !=
                                    FirebaseAuth.instance.currentUser?.uid &&
                                widget.chatController.previousChatID !=
                                    widget.chat.sentBy)
                              // Container(
                              //   // color: Colors.pink,
                              //   padding: EdgeInsets.only(left: 10, top: 5),
                              //   child: Text(
                              //     widget.chat.uid,
                              //     style:
                              //         Theme.of(context).textTheme.labelMedium,
                              //   ),
                              // ),
                              FutureBuilder<ChatUser>(
                                  future:
                                      ChatUser.fromUid(uid: widget.chat.sentBy),
                                  builder:
                                      (context, AsyncSnapshot<ChatUser> snap) {
                                    return Container(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: RichText(
                                          text: TextSpan(
                                              text: '${snap.data?.username}  ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                              children: [
                                                TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    text: DateFormat(
                                                            "MMM d y hh:mm aaa")
                                                        .format(
                                                            chat.ts.toDate())),
                                              ]),
                                        )
                                        // Text(
                                        //
                                        //
                                        // ),
                                        );
                                  }),

                            FutureBuilder<ChatUser>(
                                future:
                                    ChatUser.fromUid(uid: widget.chat.sentBy),
                                builder:
                                    (context, AsyncSnapshot<ChatUser> snap) {
                                  widget.chatController.previousChatID =
                                      widget.chat.sentBy;
                                  return SizedBox();
                                }),

                            Container(
                              constraints: const BoxConstraints(maxWidth: 320),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).primaryColor,
                              ),
                              // color: Colors.black,
                              child: Text(
                                widget.chat.message,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                            // if (chat.sentBy !=
                            //         FirebaseAuth.instance.currentUser?.uid &&
                            //     chatController.previousChatID != chat.sentBy)
                            //   Container(
                            //     color: Colors.red,
                            //     padding: chat.sentBy ==
                            //             FirebaseAuth.instance.currentUser?.uid
                            //         ? const EdgeInsets.only(right: 10)
                            //         : const EdgeInsets.only(left: 10),
                            //     child: Text(
                            //       "data",
                            //       style: Theme.of(context).textTheme.caption,
                            //     ),
                            //   )
                            // Text('Message seen by ${chat.seenBy}')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
    // );
  }
}
