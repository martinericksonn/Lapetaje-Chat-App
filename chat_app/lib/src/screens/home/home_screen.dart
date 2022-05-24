import 'package:chat_app/service_locators.dart';
import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';

import '../../service_locators.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  @override
  void initState() {
    // if (_auth.currentUser != null) {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    // }
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
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 250));
      print('scrolling to bottom');
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Signed in'),
            IconButton(
                onPressed: () async {
                  _auth.logout();
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}