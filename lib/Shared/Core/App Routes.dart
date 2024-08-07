// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Screens/Detailed/Detailed%20Anime%20Screen.dart';
import 'package:mal_app/Screens/Detailed/Detailed%20Character%20Screen.dart';
import 'package:mal_app/Screens/Floating%20Button/New%20Post%20Screen.dart';
import 'package:mal_app/Screens/Home/Home%20Screen.dart';
import 'package:mal_app/Screens/Authentication/Login%20Screen.dart';
import 'package:mal_app/Screens/Authentication/Sign%20Up%20Screen.dart';
import 'package:mal_app/Screens/Layout/Community%20Screen.dart';
import 'package:mal_app/Screens/Layout/Feed%20Screen.dart';
import 'package:mal_app/Screens/Layout/Profile%20Screen.dart';
import 'package:mal_app/Screens/Floating%20Button/Search%20Screen.dart';
import 'package:mal_app/Screens/Other/Splash%20Screen.dart';
import 'package:mal_app/Screens/Web/Webview%20Screen.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

class AppRoutes {
  static const splashScreen = SplashScreen();
  static const loginScreen = LoginScreen();
  static const signUpScreen = SignUpScreen();
  static const homeScreen = HomeScreen();
  static const profileScreen = ProfileScreen();
  static const feedScreen = FeedScreen();
  static const newPostScreen = NewPostScreen();
  static const searchScreen = SearchScreen();
  static const communityScreen = CommunityScreen();
  static webScreen(url) => WebScreen(url);
  static detailedAnimeScreen(AnimeModel model)=> DetailedAnimeScreen(model: model);
  static detailedCharacterScreen(CharacterModel model) => DetailedCharacterScreen(model);
  static Widget firstScreen() {
    String? temp_uId = CacheHelper.getData("uId");
    if (temp_uId==null) {
      return AppRoutes.loginScreen;
    }
    uId = temp_uId;
    return AppRoutes.homeScreen;
    }
}
