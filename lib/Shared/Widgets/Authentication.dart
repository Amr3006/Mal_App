// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Design/Colors.dart';

Widget AuthenticationTextFormField({
  required TextEditingController controller,
  required TextInputType TextInputType,
  required String hint, 
  IconData? prefix_icon,
  void Function()? prefix_function,
  bool obscured=false
}) {
    return Padding(
              padding: Pads.medium_Padding,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: 320.w,
                    height: 40.h,
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Gap(6),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 7, end: 5),
                            width: 320.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 4,
                                strokeAlign: BorderSide.strokeAlignCenter
                                )
                            ),
                            child: TextFormField(
                              obscureText: obscured,
                              controller: controller,
                              keyboardType: TextInputType,
                              style: TextStyle(fontSize: 18.sp,color: Colors.black),
                              cursorColor: font_color,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(prefix_icon),
                                  onPressed: prefix_function,
                                ),
                                hintText: hint,
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
  }