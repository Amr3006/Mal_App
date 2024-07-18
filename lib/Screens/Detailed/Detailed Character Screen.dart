// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Detailed%20Character%20Model.dart';
import 'package:mal_app/Logic/Charcter%20Details%20Cubit/detailed_character_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/DetailsText.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/Seperator.dart';
import 'package:mal_app/Shared/Widgets/SnackMessage.dart';

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
      create: (context) => DetailedCharacterCubit()..getCharacter(model.malId),
      child: BlocBuilder<DetailedCharacterCubit, DetailedCharacterState>(
        builder: (context, state) {
          DetailedCharacterCubit cubit = DetailedCharacterCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: main_color,
              title: Text(
                "${model.name}",
                style: GoogleFonts.nunito(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                Tooltip(
                  message: "More Info.",
                  child: IconButton(
                      onPressed: () {
                        if (model.url == null) {
                          snackMessage(
                              context: context, text: "No data available yet");
                        } else {
                          AppNavigator.push(
                              AppRoutes.webScreen(model.url), context);
                        }
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )),
                )
              ],
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
            body: ConditionalBuilder(
                condition: cubit.detailedModel != null,
                fallback: (context) => AppProgressIndicator(),
                builder: (context) {
                  DetailedCharacterModel detailedModel = cubit.detailedModel!;
                  return Stack(
                    children: [
                      Image.network(
                        "${model.image}",
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
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
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(edge))),
                              width: screen_width,
                              padding: Pads.medium_Padding,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedContainer(
                                      padding: const EdgeInsets.all(12),
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                          color: main_color,
                                          borderRadius:
                                              BorderRadius.circular(edge)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "FAVOURITES",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Expanded(
                                            child: AnimatedContainer(
                                              alignment: Alignment.center,
                                              height: 70.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          edge)),
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              child: Text(
                                                "#${detailedModel.favorites != null
                                                    ? NumberFormat('#,##0').format(detailedModel.favorites)
                                                    : "Unk."}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        main_color),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Gaps.medium_Gap,
                                    // Nicknames Section
                                    HomeTitle("Nicknames", fontSize: 20),
                                    HSeperator(),
                                    Gaps.small_Gap,
                                    Wrap(
                                      children: [
                                        if (detailedModel.nicknames != null &&
                                            detailedModel.nicknames!.isNotEmpty)
                                          for (int i = 0;
                                              i <
                                                  detailedModel
                                                      .nicknames!.length;
                                              i++)
                                            DetailsText(
                                              "",
                                              "${detailedModel.nicknames![i]}${i == detailedModel.nicknames!.length - 1 ? "" : " - "}",
                                              leading: false,
                                            )
                                        else
                                          DetailsText("", "None",
                                              leading: false)
                                      ],
                                    ),

                                    // About Section
                                    HomeTitle("About", fontSize: 20),
                                    HSeperator(),
                                    Gaps.small_Gap,
                                    DetailsText(
                                        "", detailedModel.about ?? "Unk.",
                                        leading: false),
                                    Gaps.medium_Gap,
                                  ]),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }),
          );
        },
      ),
    );
  }
}
