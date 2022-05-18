import 'package:flutter/material.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/navigation/navigation_service.dart';
import '../home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String route = 'auth-screen';

  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unCon = TextEditingController(),
      _passCon = TextEditingController();
  final AuthController _authController = locator<AuthController>();

  String prompts = '';

  @override
  void initState() {
    _authController.addListener(handleLogin);
    super.initState();
  }

  @override
  void dispose() {
    _authController.removeListener(handleLogin);
    super.dispose();
  }

  void handleLogin() {
    if (_authController.currentUser != null) {
      locator<NavigationService>().pushReplacementNamed(HomeScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _authController,
        builder: (context, Widget? w) {
          ///shows a loading screen while initializing
          if (_authController.working) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Login'),
                backgroundColor: const Color(0xFF303030),
              ),
              backgroundColor: Colors.grey[400],
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Form(
                                  key: _formKey,
                                  onChanged: () {
                                    _formKey.currentState?.validate();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                            _authController.error?.message ??
                                                ''),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Email'),
                                        controller: _unCon,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          hintText: 'Password',
                                        ),
                                        controller: _passCon,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 32),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: (_formKey
                                                            .currentState
                                                            ?.validate() ??
                                                        false)
                                                    ? () {
                                                        _authController.register(
                                                            email: _unCon.text
                                                                .trim(),
                                                            password: _passCon
                                                                .text
                                                                .trim());
                                                      }
                                                    : null,
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    primary: (_formKey
                                                                .currentState
                                                                ?.validate() ??
                                                            false)
                                                        ? const Color(
                                                            0xFF303030)
                                                        : Colors.grey),
                                                child: const Text('Register'),
                                              ),
                                              ElevatedButton(
                                                onPressed: (_formKey
                                                            .currentState
                                                            ?.validate() ??
                                                        false)
                                                    ? () {
                                                        _authController.login(
                                                            _unCon.text.trim(),
                                                            _passCon.text
                                                                .trim());
                                                      }
                                                    : null,
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    primary: (_formKey
                                                                .currentState
                                                                ?.validate() ??
                                                            false)
                                                        ? const Color(
                                                            0xFF303030)
                                                        : Colors.grey),
                                                child: const Text('Log in'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
