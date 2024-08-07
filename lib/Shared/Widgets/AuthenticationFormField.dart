// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';

import '../Design/Colors.dart';

Widget AuthenticationTextFormField(
    {required TextEditingController controller,
    required BuildContext context,
    required TextInputType TextInputType,
    required var hint,
    bool validate = true,
    String validator_message = "Please Enter Your message Here",
    IconData? prefix_icon,
    void Function()? prefix_function,
    bool obscured = false}) {
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
        Transform.translate(
          offset: Offset(6, 4),
          child: Container(
            width: 320.w,
            height: 40.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignCenter)),
          ),
        ),
        Transform.translate(
          offset: Offset(6, 4),
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 7.w, end: 20.w),
            child: TextFormField(
              obscureText: obscured,
              controller: controller,
              validator: (value) {
                if (value!.isEmpty && validate) {
                  return validator_message;
                }
                return null;
              },
              keyboardType: TextInputType,
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
              cursorColor: font_color,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(prefix_icon),
                    onPressed: prefix_function,
                  ),
                  hintText: hint,
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    ),
  );
}


