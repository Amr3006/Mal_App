// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController? controller;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()..getUser()..getFavourites()),
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
                    fallback: (context) => HomeCubit.get(context).screen[HomeCubit.get(context).current_index]);
              },
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(onPressed: () async {
                      if (state is LoadingRandomAnimeState) return;
                      if (controller != null) {
                        controller!.close();
                      }
                      await Future.wait([
                        Future.delayed(const Duration(milliseconds: 250)),
                        HomeCubit.get(context).getRandomAnime()
                      ]); 
                      controller = Scaffold.of(context).showBottomSheet((context) => RandomSheetBuilder(HomeCubit.get(context).randomAnime!, context));
                    }, icon: Tooltip(
                      message: "Get A Random Anime Recommendation",
                      child: state is LoadingRandomAnimeState ? CircularProgressIndicator(color: navigation_bar_color) : Icon(FontAwesomeIcons.dice, color: navigation_bar_color,)),
                    );
                  }
                ),
                Gaps.small_Gap
              ],
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: NeuText(
                  text: "MAL",
                  fontSize: 35,
                  strokeWidth: 2,
                  color: navigation_bar_buttons_color),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  AppNavigator.push(AppRoutes.searchScreen, context);
                },
                elevation: 10,
                backgroundColor: navigation_bar_buttons_color,
                shape: CircleBorder(),
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: navigation_bar_color,
                ),
              ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                itemCount: HomeCubit.get(context).icons.length,
                tabBuilder: (index, isActive) {
                  return Icon(
                    HomeCubit.get(context).icons[index],
                    size: isActive ? 25.w : 20.w,
                    color: isActive
                        ? navigation_bar_buttons_color
                        : Colors.grey[300],
                  );
                },
                activeIndex: HomeCubit.get(context).current_index,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                backgroundColor: navigation_bar_color,
                leftCornerRadius: 12,
                rightCornerRadius: 12,
                shadow: Shadow(
                    offset: Offset(0, -0.1),
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.3)),
                onTap: (index) {
                  HomeCubit.get(context).changePage(index);
                }),
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
        height: screen_height*2/3,
        width: screen_width*8/9,
        child: horizontalListBuilder(model, context)),
    ),
  );
  }
}
