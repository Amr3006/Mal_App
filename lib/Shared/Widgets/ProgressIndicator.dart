// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mal_app/Shared/Core/Assets.dart';

Center AppProgressIndicator() {
  return Center(
    child: LottieBuilder.asset(AssetsPaths.downloading_animation, width: 80.w),
  );
}
