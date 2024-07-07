// ignore_for_file: file_names

import 'package:flutter/material.dart';

void snackMessage(
        {required BuildContext context,
        required String text,
        bool showCloseIcon = true}) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();
          messenger.showSnackBar(SnackBar(
              content: Text(text),
              showCloseIcon: showCloseIcon,
            ));
        }