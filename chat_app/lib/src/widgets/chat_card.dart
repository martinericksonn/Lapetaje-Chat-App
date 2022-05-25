// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/chat_message_model.dart';

// ignore: must_be_immutable
class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.index,
    // required this.chat,
    required this.chat,
  }) : super(key: key);

  final int index;
  final List<ChatMessage> chat;
  // final ChatController chat;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  var isVisible = false;
  List<ChatMessage> get chat => widget.chat;
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

        alignment: chat[index].uid == FirebaseAuth.instance.currentUser?.uid
            ? Alignment.bottomRight
            : Alignment.centerLeft,
        // color: Colors.red,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Visibility(
                visible: isVisible,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  width: double.infinity,
                  // color: Colors.green,
                  child: Text(
                    DateFormat("MMM d y hh:mm aaa")
                        .format(chat[index].ts.toDate()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Container(
                // color: Colors.pink,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                alignment:
                    chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  onLongPress: () {
                    chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                        ? bottomModal(context)
                        : null;
                  },
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(index.toString()),
                      Column(
                        crossAxisAlignment: chat[index].sentBy ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if ((chat[index].sentBy !=
                                  FirebaseAuth.instance.currentUser?.uid) &&
                              (index == 0 ||
                                  chat[index - 1].sentBy != chat[index].sentBy))
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
                                    ChatUser.fromUid(uid: chat[index].sentBy),
                                builder:
                                    (context, AsyncSnapshot<ChatUser> snap) {
                                  return Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      child: Text(
                                        '${snap.data?.username}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                      // Text(
                                      //
                                      //
                                      // ),
                                      );
                                }),

                          // FutureBuilder<ChatUser>(
                          //     future:
                          //         ChatUser.fromUid(uid: widget.chat.sentBy),
                          //     builder:
                          //         (context, AsyncSnapshot<ChatUser> snap) {
                          //       widget.chatController.previousChatID =
                          //           chat[index].sentBy;
                          //       return SizedBox();
                          //     }),

                          Container(
                            constraints: const BoxConstraints(maxWidth: 320),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: chat[index].sentBy ==
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColor,
                            ),
                            // color: Colors.black,
                            child: Text(
                              chat[index].message,
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
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
            ],
          ),
        ));
    // );
  }

  Future<dynamic> bottomModal(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            child: Material(
                child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Edit'),
                leading: Icon(Icons.edit),
                onTap: () => {
                  _textController.text = chat[index].message,
                  Navigator.of(context).pop(),
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 200,
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Text("Edit",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        controller: _textController,
                                        autofocus: true,

                                        // style:
                                        //     TextStyle(fontWeight: FontWeight.bold),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          chat[index].updateMessage(
                                              _textController.text, true);

                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 12),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          child: Text(
                                            "Save",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  )
                },
              ),
              ListTile(
                title: Text('Delete'),
                leading: Icon(Icons.delete),
                onTap: () =>
                    {Navigator.of(context).pop(), chat[index].deleteMessage()},
              )
            ],
          ),
        ))),
      ),
    );
  }
}
