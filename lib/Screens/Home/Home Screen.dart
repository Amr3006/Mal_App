// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Logic/Feed%20Cubit/feed_cubit.dart';
import 'package:mal_app/Logic/Navigation%20Bar%20Cubit/navigation_bar_cubit.dart';
import 'package:mal_app/Logic/Profile%20Cubit/profile_cubit.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/NeuText.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()..getUser()),
        BlocProvider(
            create: (context) => FeedCubit()
              ..getTopAnimes()
              ..getSeasonAnimes()
              ..getPopularCharacters()
              ..scrollListenerInit()),
        BlocProvider(create: (context) => NavigationBarCubit()),
      ],
      child: BlocBuilder<NavigationBarCubit, NavigationBarState>(
        builder: (context, state) {
          return Scaffold(
            body: BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                final List<bool> conditions = [
                  FeedCubit.get(context).topAnimes.isEmpty,
                  FeedCubit.get(context).seasonAnimes.isEmpty,
                  FeedCubit.get(context).popularCharcters.isEmpty,
                  ProfileCubit.get(context).user == null
                ];
                return ConditionalBuilder(
                    condition: conditions.contains(true),
                    builder: (context) => AppProgressIndicator(),
                    fallback: (context) => NavigationBarCubit.get(context).screen[NavigationBarCubit.get(context).current_index]);
              },
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
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
                itemCount: NavigationBarCubit.get(context).icons.length,
                tabBuilder: (index, isActive) {
                  return Icon(
                    NavigationBarCubit.get(context).icons[index],
                    size: isActive ? 25.w : 20.w,
                    color: isActive
                        ? navigation_bar_buttons_color
                        : Colors.grey[300],
                  );
                },
                activeIndex: NavigationBarCubit.get(context).current_index,
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
                  NavigationBarCubit.get(context).changePage(index);
                }),
          );
        },
      ),
    );
  }
}
