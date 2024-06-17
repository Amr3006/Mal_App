  // ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';

Widget HomeTitle(
  String text
) {
    return Row(
              children: [
                Gaps.small_Gap,
                Padding(
                  padding: Pads.small_Padding,
                  child: Text(text,
                  style:GoogleFonts.montserrat(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500
                  )),
                ),
              ],
            );
  }