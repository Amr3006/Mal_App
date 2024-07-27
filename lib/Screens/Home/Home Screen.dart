// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Logic/Feed%20Cubit/feed_cubit.dart';
import 'package:mal_app/Logic/Home%20Cubit/home_cubit.dart';
import 'package:mal_app/Logic/Profile%20Cubit/profile_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/HorizontalListBuilder.dart';
import 'package:mal_app/Shared/Widgets/NeuText.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  // Animation 
  late AnimationController _animationController;
  late Animation _darkColorAnimation,
      _lightColorAnimation,
      _iconActivatedChangeAnimation,
      _iconUnactivatedChangeAnimtion,
      _iconDisappearAnimation,
      _rotationAnimation;

  IconData floatingButtonIcon = FontAwesomeIcons.magnifyingGlass;
  // Spread Sheet Controller
  PersistentBottomSheetController? _spreadSheetController;
  bool animationForward = false;
  List<IconData> icons = [
    FontAwesomeIcons.tv,
    FontAwesomeIcons.userLarge,
  ];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _darkColorAnimation =
        ColorTween(begin: anime_color_dark, end: community_color_dark)
            .animate(_animationController);

    _lightColorAnimation =
        ColorTween(begin: anime_color_light, end: community_color_light)
            .animate(_animationController);

    _iconActivatedChangeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 25, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0, end: 25), weight: 1),
    ]).animate(_animationController);

    _iconUnactivatedChangeAnimtion = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 20, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0, end: 20), weight: 1),
    ]).animate(_animationController);

    _rotationAnimation =
        Tween<double>(begin: 0, end: pi).animate(_animationController);

    _iconDisappearAnimation =
        Tween<double>(begin: 26, end: 0).animate(_animationController);

    _animationController.addStatusListener((status) {
      animationForward = status == AnimationStatus.completed || status == AnimationStatus.forward;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ProfileCubit()
              ..getUser()
              ..getFavourites()),
        BlocProvider(
            create: (context) => FeedCubit()
              ..getTopAnimes()
              ..getSeasonAnimes()
              ..getPopularCharacters()
              ..scrollListenerInit()
              ..getRecent()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            body: BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                final List<bool> conditions = [
                  FeedCubit.get(context).topAnimes.isEmpty,
                  FeedCubit.get(context).seasonAnimes.isEmpty,
                  !FeedCubit.get(context).gotRecent,
                  FeedCubit.get(context).popularCharcters.isEmpty,
                  ProfileCubit.get(context).user == null,
                  !ProfileCubit.get(context).gotFavourites
                ];
                return ConditionalBuilder(
                    condition: conditions.contains(true),
                    builder: (context) => AppProgressIndicator(),
                    fallback: (context) => HomeCubit.get(context)
                        .screens[HomeCubit.get(context).current_index]);
              },
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: Tooltip(
                message: animationForward
                    ? "Change to AnimeList"
                    : "Change to Community",
                child: IconButton(
                  onPressed: () {
                    if (_spreadSheetController != null) {
                      _spreadSheetController!.close();
                    }
                    if (animationForward) {
                      _animationController.reverse();
                      main_color = anime_color_dark;
                      secondary_color = anime_color_light;
                    } else {
                      _animationController.forward();
                      main_color = community_color_dark;
                      secondary_color = community_color_light;
                    }
                    Future.delayed(const Duration(milliseconds: 200), () {
                      HomeCubit.get(context).changeMode();
                      if (animationForward) {
                        floatingButtonIcon = FontAwesomeIcons.plus;
                        icons = [
                          FontAwesomeIcons.house,
                          FontAwesomeIcons.userLarge,
                        ];
                      } else {
                        floatingButtonIcon = FontAwesomeIcons.magnifyingGlass;
                        icons = [
                          FontAwesomeIcons.tv,
                          FontAwesomeIcons.userLarge,
                        ];
                      }
                      setState(() {});
                    });
                  },
                  icon: AnimatedBuilder(
                    animation: _animationController,
                    builder: (contex, child) => Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Icon(
                          FontAwesomeIcons.arrowsRotate,
                          color: _darkColorAnimation.value,
                        )),
                  ),
                ),
              ),
              actions: [
                _iconDisappearAnimation.value == 0 ? SizedBox() : AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => Builder(builder: (context) {
                    return IconButton(
                      iconSize: _iconDisappearAnimation.value,
                      onPressed: () async {
                        if (state is LoadingRandomAnimeState) return;
                        if (_spreadSheetController != null) {
                          _spreadSheetController!.close();
                        }
                        await Future.wait([
                          Future.delayed(const Duration(milliseconds: 250)),
                          HomeCubit.get(context).getRandomAnime()
                        ]);
                        _spreadSheetController = Scaffold.of(context)
                            .showBottomSheet((context) => RandomSheetBuilder(
                                HomeCubit.get(context).randomAnime!, context));
                      },
                      icon: Tooltip(
                          message: "Get A Random Anime Recommendation",
                          child: state is LoadingRandomAnimeState
                              ? CircularProgressIndicator(
                                  color: anime_color_dark)
                              : Icon(
                                  FontAwesomeIcons.dice,
                                  color: anime_color_dark,
                                )),
                    );
                  }),
                ),
                Gaps.small_Gap
              ],
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => NeuText(
                    text: "MAL",
                    fontSize: 35,
                    strokeWidth: 2,
                    color: _lightColorAnimation.value),
              ),
              centerTitle: true,
            ),
            floatingActionButton: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FloatingActionButton(
                  onPressed: () {
                    Widget destination = AppRoutes.searchScreen;
                    if (HomeCubit.get(context).isCommunity) destination = AppRoutes.newPostScreen;
                    AppNavigator.push(destination, context);
                  },
                  elevation: 10,
                  backgroundColor: _lightColorAnimation.value,
                  shape: CircleBorder(),
                  child: Builder(builder: (context) {
                    return Icon(
                      floatingButtonIcon,
                      size: _iconActivatedChangeAnimation.value,
                      color: _darkColorAnimation.value,
                    );
                  }),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => AnimatedBottomNavigationBar.builder(
                  itemCount: icons.length,
                  tabBuilder: (index, isActive) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context,child) => Icon(
                        icons[index],
                        size: isActive ? _iconActivatedChangeAnimation.value : _iconUnactivatedChangeAnimtion.value,
                        color: isActive
                            ? _lightColorAnimation.value
                            : Colors.grey[300],
                      ),
                    );
                  },
                  activeIndex: HomeCubit.get(context).current_index,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.defaultEdge,
                  backgroundColor: _darkColorAnimation.value,
                  leftCornerRadius: 12,
                  rightCornerRadius: 12,
                  shadow: Shadow(
                      offset: Offset(0, -0.1),
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.3)),
                  onTap: (index) {
                    HomeCubit.get(context).changePage(index);
                  }),
            ),
          );
        },
      ),
    );
  }

  Widget RandomSheetBuilder(AnimeModel model, BuildContext context) {
    return SizedBox(
      width: screen_width,
      child: Center(
        child: SizedBox(
            height: screen_height * 2 / 3,
            width: screen_width * 8 / 9,
            child: horizontalListBuilder(model, context)),
      ),
    );
  }
}
