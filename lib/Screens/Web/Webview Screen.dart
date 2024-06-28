// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatelessWidget {
  WebScreen(this.url, {super.key});

  late final String url;

  WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    controller.loadRequest(Uri.parse(url));
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      )
    );
  }
}