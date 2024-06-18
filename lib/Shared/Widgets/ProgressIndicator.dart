// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/Assets.dart';

Widget AppProgressIndicator({
  double size = 80
}) {
  return Center(
    child: Padding(
      padding: Pads.small_Padding,
      child: LottieBuilder.asset(AssetsPaths.downloading_animation, width: size.w),
    ),
  );
}
