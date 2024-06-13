// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class Gaps{
  static final small_Gap = Gap(10.r);
  static final medium_Gap = Gap(16.r);
  static final large_Gap = Gap(24.r);
}

class Pads{
  static final small_Padding = EdgeInsets.all(8.r);
  static final medium_Padding = EdgeInsets.all(16.r);
  static final large_Padding = EdgeInsets.all(24.r);
}

// Screen Dimenstions
late double screen_height;
late double screen_width;

