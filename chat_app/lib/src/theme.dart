// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black45,
      selectionHandleColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      errorStyle: TextStyle(color: Colors.black45),
      labelStyle: TextStyle(color: Colors.black45),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.white,
      secondary: Colors.black, // Your accent color
    ),
  );
}

ThemeData appThemeDark() {
  return ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white38,
      selectionHandleColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      errorStyle: TextStyle(color: Colors.white54),
      labelStyle: TextStyle(color: Colors.white54),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Color.fromARGB(255, 250, 245, 245),
      secondary: Colors.black, // Your accent color
    ),
  );
}
