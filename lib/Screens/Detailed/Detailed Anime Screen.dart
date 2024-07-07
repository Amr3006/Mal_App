// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable, non_constant_identifier_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mal_app/Logic/Anime%20Details%20Cubit/anime_details_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Episode%20Model.dart';
import 'package:mal_app/Screens/Web/Webview%20Screen.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AppNeuButton.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/Seperator.dart';
import 'package:mal_app/Shared/Widgets/SnackMessage.dart';

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
      create: (context) => DetailedAnimeCubit()..getData(model.malId),
      child: BlocBuilder<DetailedAnimeCubit, DetailedAnimeState>(
        builder: (context, state) {
          DetailedAnimeCubit cubit = DetailedAnimeCubit.get(context);
          List<bool> conditions = [cubit.gotEpisodes, cubit.gotCharacters];
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
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
              title: Text(
                "${model.titles?[0].title}",
                style: GoogleFonts.nunito(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
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
                                        "${model.score ?? "Unk."}",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        model.scoredBy != null
                                            ? "${NumberFormat('#,##0').format(model.scoredBy)} users"
                                            : "",
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
                                        model.rank != null
                                            ? "#${NumberFormat('#,##0').format(model.rank)}"
                                            : "Unk.",
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
                                        model.popularity != null
                                            ? NumberFormat('#,##0')
                                                .format(model.popularity)
                                            : "Unk.",
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
                                        model.members != null
                                            ? "#${NumberFormat('#,##0').format(model.members)}"
                                            : "Unk.",
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

                            // Information Section
                            HomeTitle("Information", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText(
                                "Episodes", "${model.episodes ?? "Unk."}"),
                            DetailsText(
                                "Duration", "${model.duration ?? "Unk."}"),
                            DetailsText("Status", "${model.status ?? "Unk."}"),
                            DetailsText("Type", "${model.type ?? "Unk."}"),
                            DetailsText("Year", "${model.year ?? "Unk."}"),
                            DetailsText("Season", "${model.season ?? "Unk."}"),
                            DetailsText("Rating", "${model.rating ?? "Unk."}"),
                            Gaps.medium_Gap,

                            // Alternative Titles Section
                            HomeTitle("Alternative Titles", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            if (model.titles != null &&
                                model.titles!.isNotEmpty)
                              for (int i = 1; i < model.titles!.length; i++)
                                DetailsText("${model.titles?[i].type}",
                                    "${model.titles?[i].title}")
                            else
                              DetailsText("", "None", leading: false),
                            Gaps.medium_Gap,

                            // Genres Section
                            HomeTitle("Genres", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            if ((model.genres != null &&
                                    model.genres!.isNotEmpty) ||
                                (model.explicitGenres != null &&
                                    model.explicitGenres!.isNotEmpty))
                              Wrap(
                                children: [
                                  for (int i = 0; i < model.genres!.length; i++)
                                    DetailsText("",
                                        "${model.genres![i].name}${i == model.genres!.length - 1 ? "" : ", "}",
                                        leading: false),
                                  for (int i = 0; i < model.explicitGenres!.length; i++)
                                    DetailsText("",
                                        "${model.explicitGenres![i].name}${i == model.explicitGenres!.length - 1 ? "" : ", "}",
                                        leading: false)
                                ],
                              )
                            else
                              DetailsText("", "Unk.", leading: false),
                            Gaps.medium_Gap,

                            // Synopsis Section
                            HomeTitle("Synopsis", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText(
                                "", model.synopsis ?? "No Synopsis to display ",
                                leading: false),
                            Gaps.medium_Gap,

                            // Background Section
                            HomeTitle("Background", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText("Background",
                                model.background ?? "No background to display ",
                                leading: false),
                            Gaps.medium_Gap,

                            ConditionalBuilder(
                                condition: conditions.contains(false),
                                builder: (context) => AppProgressIndicator(),
                                fallback: (context) => Column(
                                      children: [
                                        // Characters Section
                                        HomeTitle("Characters", fontSize: 20),
                                        HSeperator(),
                                        Gaps.small_Gap,
                                        if (cubit.characters.isNotEmpty)
                                          SizedBox(
                                            height: 250.h,
                                            child: ListView.separated(
                                              clipBehavior: Clip.none,
                                              itemBuilder: (context, index) =>
                                                  CharactersListBuilder(
                                                      cubit.characters[index]),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      Gaps.medium_Gap,
                                              itemCount:
                                                  cubit.characters.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                          )
                                        else
                                          DetailsText('',
                                              "There is no characters to display",
                                              leading: false),
                                        Gaps.medium_Gap,

                                        // Episodes Section
                                        HomeTitle("Episodes", fontSize: 20),
                                        HSeperator(),
                                        Gaps.small_Gap,
                                        if (cubit.episodes.isNotEmpty)
                                          Column(
                                            children: [
                                              ListTile(
                                                  title: Transform.translate(
                                                      offset: Offset(-12, 0),
                                                      child: Text("Name")),
                                                  trailing: Text("Score")),
                                              ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          Gaps.medium_Gap,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      cubit.episodes.length,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      EpisodesListBuilder(cubit
                                                          .episodes[index])),
                                            ],
                                          )
                                        else
                                          DetailsText('',
                                              "There is no episodes to display",
                                              leading: false)
                                      ],
                                    )),
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

  Widget EpisodesListBuilder(EpisodeModel model) {
    return AppNeuButton(
      onPress: () {
        if (model.url == null) {
          snackMessage(context: context, text: "No data available yet");
        } else {
          AppNavigator.push(AppRoutes.webScreen(model.url), context);
        }
      },
      child: ListTile(
          title:
              Text("${model.title!} ${model.filler == true ? "(filler)" : ""}"),
          trailing: Text("${model.score!}/5")),
    );
  }

  Widget CharactersListBuilder(CharacterModel model) {
    return AppNeuButton(
      shadowColor: Colors.black,
      onPress: () {
        AppNavigator.push(AppRoutes.detailedCharacterScreen(model), context);
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 180.w,
        height: 250.h,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Expanded(
              child: Image.network(
                width: 180.w,
                model.image!,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: AlignmentDirectional.bottomStart,
              width: 180.w,
              height: 50.h,
              padding: EdgeInsetsDirectional.only(start: 8, bottom: 4),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ])),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                "${model.name}",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
