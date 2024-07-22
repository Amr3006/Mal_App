// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Design/Colors.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool animationForward = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.forward) {
        animationForward = true;
      } else if (status == AnimationStatus.dismissed ||
          status == AnimationStatus.reverse) {
        animationForward = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              bottom: _animationController.value * (screen_height/6),
              child: FloatingActionButton.small(
                onPressed: () {
                },
                shape: const CircleBorder(),
                backgroundColor: secondary_color,
                child: Icon(
                  FontAwesomeIcons.image,
                  color: main_color,
                  size: 20.r,
                ),
              ),
            ),
            Positioned(
              bottom: _animationController.value * (screen_height/12),
              child: FloatingActionButton.small(
                onPressed: () {
                },
                shape: const CircleBorder(),
                backgroundColor: secondary_color,
                child: Icon(
                  FontAwesomeIcons.clapperboard,
                  color: main_color,
                  size: 20.r,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                if (animationForward) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
              shape: const CircleBorder(),
              backgroundColor: secondary_color,
              child: Transform.rotate(
                  angle: _animationController.value * (pi / 4),
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: main_color,
                    size: 26.r,
                  )),
            ),
            
          ],
        ),
      ),
    );
  }
}
