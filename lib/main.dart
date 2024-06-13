import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Business%20Logic/Bloc%20Observer.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/firebase_options.dart';

FirebaseOptions firebaseOptions() {
  String appId="";
  String apiKey="";
  if (Platform.isIOS) {
    apiKey = "AIzaSyC4ay9pcQwdorruePZMqezLd7LuiUhtQyI";
    appId = "1:603939798895:ios:425b8655914d3f9452b29a";
  } else {
    apiKey = "AIzaSyAn_75dT35DvRhkLPIoNP_TOjUQAPz9e9I";
    appId = "1:603939798895:android:84dc1ac5bb4f2e0b52b29a";
  }
  return FirebaseOptions(
    apiKey: apiKey, 
    appId: appId, 
    messagingSenderId: "0", 
    projectId: "mal-app-450a8",
    storageBucket: "mal-app-450a8.appspot.com");
}
void main() async { 
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    // Getting Screen Dimensions
    var size = MediaQuery.of(context).size;
    screen_height = size.height;
    screen_width = size.width;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AppRoutes.splashScreen,
        ); 
      },
    );
  }
}