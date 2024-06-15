// ignore_for_file: file_names

import 'package:flutter/material.dart';

void snackMessage(
        {required BuildContext context,
        required String text,
        bool showCloseIcon = true}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      showCloseIcon: showCloseIcon,
    ));