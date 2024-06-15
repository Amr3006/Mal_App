// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Screens/Home%20Screen.dart';
import 'package:mal_app/Screens/Login%20Screen.dart';
import 'package:mal_app/Screens/Sign%20Up%20Screen.dart';
import 'package:mal_app/Screens/Splash%20Screen.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

class AppRoutes {
  static const  splashScreen = SplashScreen();
  static const loginScreen = LoginScreen();
  static const signUpScreen = SignUpScreen();
  static const homeScreen = HomeScreen();
}

Widget firstScreen() {
  String? temp_uId = CacheHelper.getData("uId");
  if (temp_uId==null) {
    return AppRoutes.loginScreen;
  }
  uId = temp_uId;
  return AppRoutes.homeScreen;
  }