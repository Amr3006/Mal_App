// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget DetailsText(String dataName, String data, {bool leading = true}) {
    return Text.rich(TextSpan(children: [
      if (leading)
      TextSpan(
          text: "$dataName: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
      TextSpan(text: data, style: TextStyle(fontSize: 16.sp)),
    ]));
  }