// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mal_app/Business%20Logic/Anime%20Details%20Cubit/anime_details_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/Seperator.dart';

import '../../Shared/Widgets/DetailsText.dart';

class DetailedAnimeScreen extends StatefulWidget {
  final AnimeModel model;

  const DetailedAnimeScreen({super.key, required this.model});

  @override
  State<DetailedAnimeScreen> createState() => _DetailedAnimeScreenState();
}

class _DetailedAnimeScreenState extends State<DetailedAnimeScreen> {
  late final AnimeModel model;
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
        await Future.delayed(Duration(milliseconds: 150));
        opacity = 0.85;
        setState(() {});
      } else {
        opacity = 1;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 150));
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
      create: (context) => DetailedAnimeCubit()..getData(model.malId),
      child: BlocBuilder<DetailedAnimeCubit, DetailedAnimeState>(
        builder: (context, state) {
          DetailedAnimeCubit cubit = DetailedAnimeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: navigation_bar_color,
              actions: [IconButton(
                onPressed: () {

                }, 
                icon: Icon(FontAwesomeIcons.info, color: Colors.white,))],
              leading: IconButton(
                onPressed: () {
                  AppNavigator.pop(context);
                },
                icon: const Icon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "${model.titles?[0].title}",
                style: GoogleFonts.nunito(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Hero(
                  tag: "gibberish",
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
                            Gaps.large_Gap,
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 6),
                                        color: navigation_bar_color,
                                        child: Text(
                                          "SCORE",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "${model.score}",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${NumberFormat('#,##0').format(model.scoredBy)} users",
                                        style: TextStyle(fontSize: 10.sp),
                                      )
                                    ],
                                  ),
                                ),
                                VSeperator(),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 6),
                                        color: navigation_bar_color,
                                        child: Text(
                                          "RANKED",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "#${NumberFormat('#,##0').format(model.rank)}",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gaps.medium_Gap,
                            HSeperator(leftMargin: 0),
                            Gaps.medium_Gap,
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 6),
                                        color: navigation_bar_color,
                                        child: Text(
                                          "POPULARITY",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "${NumberFormat('#,##0').format(model.popularity)}",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                VSeperator(),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 6),
                                        color: navigation_bar_color,
                                        child: Text(
                                          "MEMBERS",
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "#${NumberFormat('#,##0').format(model.members)}",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gaps.huge_Gap,
                            HomeTitle("Information", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText("Episodes", "${model.episodes}"),
                            DetailsText("Duration", "${model.duration}"),
                            DetailsText("Status", "${model.status}"),
                            DetailsText("Year", "${model.year}"),
                            DetailsText("Rating", "${model.rating}"),
                            Gaps.medium_Gap,
                            HomeTitle("Alternative Titles", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            for (int i = 1; i < model.titles!.length; i++)
                              DetailsText("${model.titles?[i].type}",
                                  "${model.titles?[i].title}"),
                            HomeTitle("Synopsis", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText("Sypnosis", "${model.synopsis}"),
                            Gaps.medium_Gap,
                          ],
                        ),
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
  }
}
