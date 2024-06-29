// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Logic/Charcter%20Details%20Cubit/detailed_character_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AppNeuButton.dart';
import 'package:mal_app/Shared/Widgets/DetailsText.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/Seperator.dart';

class DetailedCharacterScreen extends StatefulWidget {
  const DetailedCharacterScreen(this.model, {super.key});

  final CharacterModel model;

  @override
  State<DetailedCharacterScreen> createState() =>
      _DetailedCharacterScreenState();
}

class _DetailedCharacterScreenState extends State<DetailedCharacterScreen> {
  late final CharacterModel model;
  final controller = ScrollController();
  double edge = 0;
  double opacity = 1;
  double? imageHeight;
  double? imageWidth = screen_width;

  @override
  void initState() {
    model = widget.model;
    controller.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() async {
    if (controller.position.extentBefore > 25) {
      edge = 20;
      if (controller.position.extentBefore >= screen_height) {
        imageWidth = null;
        imageHeight = screen_height;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 150));
        opacity = 0.9;
        setState(() {});
      } else {
        opacity = 1;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 150));
        imageHeight = null;
        imageWidth = screen_width;
        setState(() {});
      }
    } else {
      edge = 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailedCharacterCubit(),
      child: BlocBuilder<DetailedCharacterCubit, DetailedCharacterState>(
        builder: (context, state) {
          DetailedCharacterCubit cubit = DetailedCharacterCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: navigation_bar_color,
              leading: IconButton(
                onPressed: () {
                  AppNavigator.pop(context);
                },
                icon: const Icon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.white,
                ),
              ),
            ),
            body: Stack(
              children: [
                Hero(
                  tag: "gibberish345",
                  child: Image.network(
                    "${model.image}",
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Opacity(
                          opacity: 0,
                          child: Image.network(
                            "${model.image}",
                            width: screen_width,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                          )),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(edge)),
                        width: screen_width,
                        padding: Pads.medium_Padding,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gaps.medium_Gap,

                              // Information Section
                              HomeTitle("Information", fontSize: 20),
                              HSeperator(),
                              Gaps.small_Gap,
                              // Alternative Titles Section
                              HomeTitle("Alternative Titles", fontSize: 20),
                              HSeperator(),

                              // Genres Section
                              HomeTitle("Genres", fontSize: 20),
                              HSeperator(),

                              // Synopsis Section
                              HomeTitle("Synopsis", fontSize: 20),
                              HSeperator(),
                              Gaps.small_Gap,
                              DetailsText("", "${model}", leading: false),
                              Gaps.medium_Gap,

                              // Background Section
                              HomeTitle("Background", fontSize: 20),
                              HSeperator(),
                              Gaps.small_Gap,
                              DetailsText("Background", "${model}",
                                  leading: false),
                              Gaps.medium_Gap,
                            ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
    ;
  }
}
