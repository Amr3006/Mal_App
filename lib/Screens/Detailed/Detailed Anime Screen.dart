// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable, non_constant_identifier_names

import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Logic/Anime%20Details%20Cubit/anime_details_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Episode%20Model.dart';
// ignore: unused_import
import 'package:mal_app/Logic/Profile%20Cubit/profile_cubit.dart';
import 'package:mal_app/Shared/Constants/Data.dart';
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

class _DetailedAnimeScreenState extends State<DetailedAnimeScreen>
    with TickerProviderStateMixin {
  late final AnimeModel model;
  late final AnimationController _favAnimationController, _scrollAnimationController;
  final controller = ScrollController();
  final buttonKey = GlobalKey<TooltipState>(),
      moreInfoKey = GlobalKey<TooltipState>();
  late final Animation _colorAnimation, _popAnimation;
  bool opened = false;

  bool favAnimationForward = false, scrollAnimationForward = false;

  @override
  void dispose() {
    _favAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    model = widget.model;

    // Scroll Animation Controller
    _scrollAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));

    // Favourites Button Animation
    _favAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));


    _colorAnimation = user!.favourites.contains(model.malId)
        ? ColorTween(begin: Colors.pink, end: main_color)
            .animate(_favAnimationController)
        : ColorTween(begin: main_color, end: Colors.pink)
            .animate(_favAnimationController);

    _popAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 26, end: 35), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 35, end: 26), weight: 1)
    ]).animate(_favAnimationController);

    _favAnimationController.addStatusListener((status) {
      favAnimationForward = status == AnimationStatus.completed || status == AnimationStatus.forward;
    });

    _scrollAnimationController.addStatusListener((status) {
      scrollAnimationForward = status == AnimationStatus.completed || status == AnimationStatus.forward;
    });

    // Scroll Listener
    controller.addListener(scrollListener);

    // Show Tooltip if Firsttime
    if (CacheHelper.getData("isFirstTime") == true) {
      opened = true;
      return;
    }
    CacheHelper.saveData("isFirstTime", true);
    Future.delayed(const Duration(milliseconds: 50), () {
      buttonKey.currentState!.ensureTooltipVisible();
      moreInfoKey.currentState!.ensureTooltipVisible();
      Future.delayed(const Duration(seconds: 4), () {
        Tooltip.dismissAllToolTips();
        opened = true;
        setState(() {});
      });
    });
    super.initState();
  }

  void scrollListener() async {
    if (controller.position.extentBefore > (screen_height*2/5)-20) {
      if (scrollAnimationForward) return;
      _scrollAnimationController.forward();
    } else {
      if (!scrollAnimationForward) return;
      _scrollAnimationController.reverse();
    }
        setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailedAnimeCubit()
        ..getData(model.malId)
        ..addToRecentlyOpened(model),
      child: BlocBuilder<DetailedAnimeCubit, DetailedAnimeState>(
        builder: (context, state) {
          DetailedAnimeCubit cubit = DetailedAnimeCubit.get(context);
          List<bool> conditions = [cubit.gotEpisodes, cubit.gotCharacters];
          return Scaffold(
            floatingActionButton: FloatingActionButton.small(
              backgroundColor: secondary_color,
              onPressed: () {
                cubit.changeFavourites(model);
                if (favAnimationForward) {
                  _favAnimationController.reverse();
                } else {
                  _favAnimationController.forward();
                }
              },
              child: Tooltip(
                  key: buttonKey,
                  textStyle: opened
                      ? null
                      : TextStyle(fontSize: 24.sp, color: Colors.white),
                  decoration: opened
                      ? null
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: anime_color_dark),
                  message: "Add to Favourites",
                  child: AnimatedBuilder(
                    animation: _favAnimationController,
                    builder: (context, child) => Icon(
                      Icons.favorite,
                      size: _popAnimation.value,
                      color: _colorAnimation.value,
                    ),
                  )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            backgroundColor: Colors.white,
            body: CustomScrollView(
              clipBehavior: Clip.none,
              controller: controller,
              slivers: [
                AnimatedBuilder(
                  animation: _scrollAnimationController,
                  builder: (context,_) => SliverAppBar(
                      actions: [
                  Tooltip(
                    textStyle: opened
                        ? null
                        : TextStyle(fontSize: 24.sp, color: Colors.white),
                    decoration: opened
                        ? null
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: anime_color_dark),
                    message: "More Info.",
                    key: moreInfoKey,
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
                    bottom: PreferredSize(preferredSize: Size.fromHeight(32 - _scrollAnimationController.value*32), 
                    child: Container(
                      height: 32 - _scrollAnimationController.value*32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32 - _scrollAnimationController.value*32))
                      ),
                      child: Container(
                        width: 50,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    )),
                    leading: IconButton(onPressed: () {AppNavigator.pop(context);}, icon: Container(
                      decoration: BoxDecoration(
                      color: anime_color_dark.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50),
                      ),
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Icon(Icons.arrow_back)),
                      ),
                    ), color: Colors.white,),
                    backgroundColor: anime_color_dark,
                    expandedHeight: screen_height*3/5,
                    pinned: true,
                    elevation: 0,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.fadeTitle,
                        StretchMode.zoomBackground
                      ],
                      titlePadding: EdgeInsets.only(bottom: 35 - _scrollAnimationController.value*35+10),
                      centerTitle: true,
                      title: Text(model.titles!.first.title!, style: TextStyle(color: Colors.white),),
                      background: Image.network(model.image!, fit: BoxFit.cover,),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: Pads.medium_Padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        color: main_color,
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
                                        color: main_color,
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
                                        color: main_color,
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
                                        color: main_color,
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
                                  for (int i = 0;
                                      i < model.explicitGenres!.length;
                                      i++)
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
                                "", 
                                model.synopsis==null || model.synopsis!.isEmpty ? "No synopsis to display " : model.synopsis!,
                                leading: false),
                            Gaps.medium_Gap,

                            // Background Section
                            HomeTitle("Background", fontSize: 20),
                            HSeperator(),
                            Gaps.small_Gap,
                            DetailsText("",
                                model.background==null || model.background!.isEmpty ? "No background to display " : model.background!,
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
                    ],)
                  )
              ],
            ),

            
            // appBar: AppBar(
            //   backgroundColor: main_color,
            //   leading: IconButton(
            //     onPressed: () {
            //       AppNavigator.pop(context);
            //     },
            //     icon: const Icon(
            //       FontAwesomeIcons.angleLeft,
            //       color: Colors.white,
            //     ),
            //   ),
            //   title: Text(
            //     "${model.titles?[0].title}",
            //     style: GoogleFonts.nunito(
            //         color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // body: Stack(
            //   children: [
            //     Image.network(
            //       "${model.image}",
            //       width: imageWidth,
            //       height: imageHeight,
            //       fit: BoxFit.cover,
            //       filterQuality: FilterQuality.medium,
            //     ),
            //     SingleChildScrollView(
            //       controller: controller,
            //       child: Column(
            //         children: [
            //           Opacity(
            //               opacity: 0,
            //               child: Image.network(
            //                 "${model.image}",
            //                 width: screen_width,
            //                 fit: BoxFit.cover,
            //                 filterQuality: FilterQuality.none,
            //               )),
            //           AnimatedContainer(
            //             duration: const Duration(milliseconds: 100),
            //             decoration: BoxDecoration(
            //                 color: Colors.white.withOpacity(opacity),
            //                 borderRadius: BorderRadius.vertical(
            //                     top: Radius.circular(edge))),
            //             width: screen_width,
            //             padding: Pads.medium_Padding,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Gaps.large_Gap,
            //                 Row(
            //                   textBaseline: TextBaseline.alphabetic,
            //                   crossAxisAlignment: CrossAxisAlignment.baseline,
            //                   children: [
            //                     Expanded(
            //                       child: Column(
            //                         children: [
            //                           Container(
            //                             padding: EdgeInsets.symmetric(
            //                                 vertical: 2, horizontal: 6),
            //                             color: main_color,
            //                             child: Text(
            //                               "SCORE",
            //                               style: TextStyle(
            //                                   fontSize: 20.sp,
            //                                   fontWeight: FontWeight.w500,
            //                                   color: Colors.white),
            //                             ),
            //                           ),
            //                           Text(
            //                             "${model.score ?? "Unk."}",
            //                             style: TextStyle(
            //                                 fontSize: 28.sp,
            //                                 fontWeight: FontWeight.bold),
            //                           ),
            //                           Text(
            //                             model.scoredBy != null
            //                                 ? "${NumberFormat('#,##0').format(model.scoredBy)} users"
            //                                 : "",
            //                             style: TextStyle(fontSize: 10.sp),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                     VSeperator(),
            //                     Expanded(
            //                       child: Column(
            //                         children: [
            //                           Container(
            //                             padding: EdgeInsets.symmetric(
            //                                 vertical: 2, horizontal: 6),
            //                             color: main_color,
            //                             child: Text(
            //                               "RANKED",
            //                               style: TextStyle(
            //                                   fontSize: 20.sp,
            //                                   fontWeight: FontWeight.w500,
            //                                   color: Colors.white),
            //                             ),
            //                           ),
            //                           Text(
            //                             model.rank != null
            //                                 ? "#${NumberFormat('#,##0').format(model.rank)}"
            //                                 : "Unk.",
            //                             style: TextStyle(
            //                                 fontSize: 28.sp,
            //                                 fontWeight: FontWeight.bold),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 Gaps.medium_Gap,
            //                 HSeperator(leftMargin: 0),
            //                 Gaps.medium_Gap,
            //                 Row(
            //                   textBaseline: TextBaseline.alphabetic,
            //                   crossAxisAlignment: CrossAxisAlignment.baseline,
            //                   children: [
            //                     Expanded(
            //                       child: Column(
            //                         children: [
            //                           Container(
            //                             padding: EdgeInsets.symmetric(
            //                                 vertical: 2, horizontal: 6),
            //                             color: main_color,
            //                             child: Text(
            //                               "POPULARITY",
            //                               style: TextStyle(
            //                                   fontSize: 20.sp,
            //                                   fontWeight: FontWeight.w500,
            //                                   color: Colors.white),
            //                             ),
            //                           ),
            //                           Text(
            //                             model.popularity != null
            //                                 ? NumberFormat('#,##0')
            //                                     .format(model.popularity)
            //                                 : "Unk.",
            //                             style: TextStyle(
            //                                 fontSize: 28.sp,
            //                                 fontWeight: FontWeight.bold),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     VSeperator(),
            //                     Expanded(
            //                       child: Column(
            //                         children: [
            //                           Container(
            //                             padding: EdgeInsets.symmetric(
            //                                 vertical: 2, horizontal: 6),
            //                             color: main_color,
            //                             child: Text(
            //                               "MEMBERS",
            //                               style: TextStyle(
            //                                   fontSize: 20.sp,
            //                                   fontWeight: FontWeight.w500,
            //                                   color: Colors.white),
            //                             ),
            //                           ),
            //                           Text(
            //                             model.members != null
            //                                 ? "#${NumberFormat('#,##0').format(model.members)}"
            //                                 : "Unk.",
            //                             style: TextStyle(
            //                                 fontSize: 28.sp,
            //                                 fontWeight: FontWeight.bold),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 Gaps.medium_Gap,

            //                 // Information Section
            //                 HomeTitle("Information", fontSize: 20),
            //                 HSeperator(),
            //                 Gaps.small_Gap,
            //                 DetailsText(
            //                     "Episodes", "${model.episodes ?? "Unk."}"),
            //                 DetailsText(
            //                     "Duration", "${model.duration ?? "Unk."}"),
            //                 DetailsText("Status", "${model.status ?? "Unk."}"),
            //                 DetailsText("Type", "${model.type ?? "Unk."}"),
            //                 DetailsText("Year", "${model.year ?? "Unk."}"),
            //                 DetailsText("Season", "${model.season ?? "Unk."}"),
            //                 DetailsText("Rating", "${model.rating ?? "Unk."}"),
            //                 Gaps.medium_Gap,

            //                 // Alternative Titles Section
            //                 HomeTitle("Alternative Titles", fontSize: 20),
            //                 HSeperator(),
            //                 Gaps.small_Gap,
            //                 if (model.titles != null &&
            //                     model.titles!.isNotEmpty)
            //                   for (int i = 1; i < model.titles!.length; i++)
            //                     DetailsText("${model.titles?[i].type}",
            //                         "${model.titles?[i].title}")
            //                 else
            //                   DetailsText("", "None", leading: false),
            //                 Gaps.medium_Gap,

            //                 // Genres Section
            //                 HomeTitle("Genres", fontSize: 20),
            //                 HSeperator(),
            //                 Gaps.small_Gap,
            //                 if ((model.genres != null &&
            //                         model.genres!.isNotEmpty) ||
            //                     (model.explicitGenres != null &&
            //                         model.explicitGenres!.isNotEmpty))
            //                   Wrap(
            //                     children: [
            //                       for (int i = 0; i < model.genres!.length; i++)
            //                         DetailsText("",
            //                             "${model.genres![i].name}${i == model.genres!.length - 1 ? "" : ", "}",
            //                             leading: false),
            //                       for (int i = 0;
            //                           i < model.explicitGenres!.length;
            //                           i++)
            //                         DetailsText("",
            //                             "${model.explicitGenres![i].name}${i == model.explicitGenres!.length - 1 ? "" : ", "}",
            //                             leading: false)
            //                     ],
            //                   )
            //                 else
            //                   DetailsText("", "Unk.", leading: false),
            //                 Gaps.medium_Gap,

            //                 // Synopsis Section
            //                 HomeTitle("Synopsis", fontSize: 20),
            //                 HSeperator(),
            //                 Gaps.small_Gap,
            //                 DetailsText(
            //                     "", 
            //                     model.synopsis==null || model.synopsis!.isEmpty ? "No synopsis to display " : model.synopsis!,
            //                     leading: false),
            //                 Gaps.medium_Gap,

            //                 // Background Section
            //                 HomeTitle("Background", fontSize: 20),
            //                 HSeperator(),
            //                 Gaps.small_Gap,
            //                 DetailsText("",
            //                     model.background==null || model.background!.isEmpty ? "No background to display " : model.background!,
            //                     leading: false),
            //                 Gaps.medium_Gap,

            //                 ConditionalBuilder(
            //                     condition: conditions.contains(false),
            //                     builder: (context) => AppProgressIndicator(),
            //                     fallback: (context) => Column(
            //                           children: [
            //                             // Characters Section
            //                             HomeTitle("Characters", fontSize: 20),
            //                             HSeperator(),
            //                             Gaps.small_Gap,
            //                             if (cubit.characters.isNotEmpty)
            //                               SizedBox(
            //                                 height: 250.h,
            //                                 child: ListView.separated(
            //                                   clipBehavior: Clip.none,
            //                                   itemBuilder: (context, index) =>
            //                                       CharactersListBuilder(
            //                                           cubit.characters[index]),
            //                                   separatorBuilder:
            //                                       (context, index) =>
            //                                           Gaps.medium_Gap,
            //                                   itemCount:
            //                                       cubit.characters.length,
            //                                   shrinkWrap: true,
            //                                   scrollDirection: Axis.horizontal,
            //                                 ),
            //                               )
            //                             else
            //                               DetailsText('',
            //                                   "There is no characters to display",
            //                                   leading: false),
            //                             Gaps.medium_Gap,

            //                             // Episodes Section
            //                             HomeTitle("Episodes", fontSize: 20),
            //                             HSeperator(),
            //                             Gaps.small_Gap,
            //                             if (cubit.episodes.isNotEmpty)
            //                               Column(
            //                                 children: [
            //                                   ListTile(
            //                                       title: Transform.translate(
            //                                           offset: Offset(-12, 0),
            //                                           child: Text("Name")),
            //                                       trailing: Text("Score")),
            //                                   ListView.separated(
            //                                       separatorBuilder:
            //                                           (context, index) =>
            //                                               Gaps.medium_Gap,
            //                                       shrinkWrap: true,
            //                                       physics:
            //                                           NeverScrollableScrollPhysics(),
            //                                       itemCount:
            //                                           cubit.episodes.length,
            //                                       itemBuilder: (context,
            //                                               index) =>
            //                                           EpisodesListBuilder(cubit
            //                                               .episodes[index])),
            //                                 ],
            //                               )
            //                             else
            //                               DetailsText('',
            //                                   "There is no episodes to display",
            //                                   leading: false)
            //                           ],
            //                         )),
            //               ],
            //             ),
            //           )
            //         ],
            //       ),
            //     )
            //   ],
            // ),
          );
        },
      ),
    );
  }

  Widget EpisodesListBuilder(EpisodeModel model) {
    return AppNeuButton(
      onPressed: () {
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
      onPressed: () {
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
