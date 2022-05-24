// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  final AuthController auth;

  const RegisterScreen(
    this.auth, {
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;
  bool isUsernameEmpty = false;
  bool isRegisterSuccess = false;
  String prompts = '';

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _unCon = TextEditingController();

  AuthController get _auth => widget.auth;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: appBar(context),
        // ignore: prefer_const_literals_to_create_immutables
        body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Form(
              onChanged: () => setState(() {
                prompts = "";
              }),
              key: _formKey,
              child: Column(
                children: [
                  upperBody(context),
                  lowerBody(context),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding lowerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SizedBox(
        // color: Colors.pink,
        height: MediaQuery.of(context).size.height * 0.55,
        // color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Column(
              children: [
                title(),
                // SizedBox(height: 15),
                usernameTextField(context),
                emailTextField(context),
                passwordTextField(context),
              ],
            ),
            promptMessage(),
            Column(
              children: [
                registerButton(context),
                loginButton(context),
              ],
            ),
            // TextFormField(),
          ],
        ),
      ),
    );
  }

  Text promptMessage() {
    return Text(
      prompts,
      style: TextStyle(
        color: isRegisterSuccess ? Colors.green : Colors.red,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget loginButton(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Joined us before? ",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                // backgroundColor: Colors.red,
                minimumSize: Size(10, 10),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> register() async {
    try {
      await _auth.register(
          username: _unCon.text.trim(),
          email: _emailCon.text.trim(),
          password: _passCon.text.trim());
    } catch (error) {
      prompts = error.toString();
    }
  }

  TextButton registerButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // print(_unCon.text);
        // print(_emailCon.text);
        // print(_passCon.text);
        // print(_formKey.currentState!.validate() && isFieldEmpty());
        if (_formKey.currentState!.validate() && isFieldEmpty()) {
          setState(() {
            register();
          });
        } else {
          setState(() {
            prompts = "Fields cannot be empty";
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: 60,
        // padding:
        //     EdgeInsets.symmetric(horizontal: 30, vertical: 22),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Container forgetPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forget password?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Container title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      alignment: Alignment.topLeft,
      child: Text(
        "Join Tasuku now.",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container passwordTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isPasswordEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.secondary, // set border

              width: isPasswordEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _passCon,
          validator: (value) {
            setState(() {
              isPasswordEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isPasswordEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary),
            hintText: "Password",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container usernameTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isUsernameEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.secondary,
              width: isUsernameEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _unCon,
          validator: (value) {
            setState(() {
              isUsernameEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isUsernameEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary),
            hintText: "Username",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Container emailTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: isEmailEmpty
                  ? Colors.red
                  : Theme.of(context).colorScheme.secondary,
              // Colors.red,

              width: isEmailEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          controller: _emailCon,
          validator: (value) {
            setState(() {
              isEmailEmpty = (value == null || value.isEmpty) ? true : false;
            });
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
                color: isEmailEmpty
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary),
            hintText: "Email",
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Stack upperBody(BuildContext context) {
    return Stack(children: [
      Container(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          child: Text(
            "Tasuku",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.40,
        padding: EdgeInsets.only(top: 18.0),
        child: Image(
          image: AssetImage("assets/images/register.png"),
        ),
      )
    ]);
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        alignment: Alignment.centerRight,
        child: Text(
          "Tasuku",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool isFieldEmpty() {
    return !(isEmailEmpty || isPasswordEmpty || isUsernameEmpty);
  }
}
