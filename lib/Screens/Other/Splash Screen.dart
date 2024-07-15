// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Core/Assets.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    changeScreen(context);
  }

  Future<void> changeScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    AppNavigator.pushReplacement(AppRoutes.firstScreen(),context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SvgPicture.asset(
                      AssetsPaths.splash_screen_icon,
                      width: 250.w,
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LottieBuilder.asset(
                          AssetsPaths.splash_screen_animation,
                          width: 250.w
                          ),
                          Gap(14.w)
                      ],
                    )
                  ],
                ),
                Gaps.medium_Gap,
                Text(
                  "MAL App",
                  style: GoogleFonts.happyMonkey().copyWith(
                    color: Colors.black,
                    fontSize: 44.sp
                  ),
                  )
              ],
            ),
          ),
        )
      ),
    );
  }
}
