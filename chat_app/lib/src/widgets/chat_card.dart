// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/bottom_sheet.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Visibility(
            visible: isVisible,
            child: Container(
              padding: EdgeInsets.only(bottom: 5, top: 15),
              alignment: Alignment.center,
              width: double.infinity,
              // color: Colors.green,
              child: Text(
                DateFormat("MMM d, y hh:mm aaa")
                    .format(chat[index].ts.toDate()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              // Text('asd'),
              Visibility(
                visible: chat[index].isEdited
                    ? chat[index].sentBy ==
                        FirebaseAuth.instance.currentUser?.uid
                    : false,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '(edited)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  onLongPress: () {
                    chat[index].isDeleted
                        ? null
                        : chat[index].sentBy ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? bottomModal(context)
                            : null;
                  },
                  child: Column(
                    crossAxisAlignment: chat[index].sentBy ==
                            FirebaseAuth.instance.currentUser?.uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if ((chat[index].sentBy !=
                              FirebaseAuth.instance.currentUser?.uid) &&
                          (index == 0 ||
                              chat[index - 1].sentBy != chat[index].sentBy))
                        FutureBuilder<ChatUser>(
                            future: ChatUser.fromUid(uid: chat[index].sentBy),
                            builder: (context, AsyncSnapshot<ChatUser> snap) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, bottom: 3),
                                  child: Text(
                                    '${snap.data?.username}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ));
                            }),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 320),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: chat[index].isDeleted
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: chat[index].isDeleted
                              ? Colors.transparent
                              : chat[index].sentBy ==
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColor,
                        ),
                        // color: Colors.black,
                        child: Text(
                          chat[index].message,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: chat[index].isEdited
                    ? chat[index].sentBy ==
                            FirebaseAuth.instance.currentUser?.uid
                        ? false
                        : true
                    : false,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '(edited)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // );
  }

  Future<dynamic> bottomModal(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: BottomSheetModal(
            chat: chat[index],
          )),
    );
  }
}
