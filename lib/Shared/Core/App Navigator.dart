// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppNavigator {

  static void push(Widget screen, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen,));
  }

  static void pushReplacement(Widget screen, BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
  }

}
