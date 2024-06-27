// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/Dimensions.dart';

Widget HSeperator({double leftMargin = 15}) {
  return Container(
    height: 2,
    width: screen_width - 10,
    margin: EdgeInsets.only(left: leftMargin, top: 4, bottom: 4),
    color: Colors.grey,
  );
}

Widget VSeperator() {
  return Container(
    height: 60.h,
    margin: const EdgeInsets.only(top: 20),
    width: 2,
    color: Colors.grey,
  );
}
