// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_message_model.dart';
import '../../models/chat_user_model.dart';

import '../../service_locators.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  final ChatController _chatController = ChatController();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ChatUser? user;
  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    _chatController.addListener(scrollToBottom);
    super.initState();
  }

  @override
  void dispose() {
    _chatController.removeListener(scrollToBottom);
    _messageFN.dispose();
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    print('scrolling to bottom');
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chatting from ${user?.username ?? '...'}'),
        actions: [
          IconButton(
              onPressed: () {
                _auth.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                  animation: _chatController,
                  builder: (context, Widget? w) {
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            for (ChatMessage chat in _chatController.chats)
                              ChatCard(chat: chat)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        send();
                      },
                      focusNode: _messageFN,
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.redAccent,
                    ),
                    onPressed: send,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  send() {
    _messageFN.unfocus();
    if (_messageController.text.isNotEmpty) {
      _chatController.sendMessage(message: _messageController.text.trim());
      _messageController.text = '';
    }
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final ChatMessage chat;

  isYOU() {}
  @override
  Widget build(BuildContext context) {
    return Container(

        // width: 300,
        // color: Colors.red,
        alignment: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
            ? Alignment.bottomRight
            : Alignment.centerLeft,
        child:
            // Container(
            //   // width: chat.message.length * 20,
            //   margin: const EdgeInsets.all(6),
            //   padding: const EdgeInsets.all(8),
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(8)),
            //     // color: Colors.black,
            //   ),
            //   child:
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
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
                    FutureBuilder<ChatUser>(
                        future: ChatUser.fromUid(uid: chat.sentBy),
                        builder: (context, AsyncSnapshot<ChatUser> snap) {
                          if (snap.hasData &&
                              chat.sentBy !=
                                  FirebaseAuth.instance.currentUser?.uid) {
                            return Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                '${snap.data?.username}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                    Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                              ? EdgeInsets.only(right: 10)
                              : EdgeInsets.only(left: 10),
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
