// ignore_for_file: file_names, prefer_const_constructors

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Business%20Logic/Anime%20Cubit/anime_cubit.dart';
import 'package:mal_app/Business%20Logic/Navigation%20Bar%20Cubit/navigation_bar_cubit.dart';
import 'package:mal_app/Business%20Logic/User%20Cubit/user_cubit.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/NeuText.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()..getUser()),
        BlocProvider(create: (context) => AnimeCubit()),
        BlocProvider(create: (context) => NavigationBarCubit()),
      ],
      child: BlocBuilder<NavigationBarCubit, NavigationBarState>(
        builder: (context, state) {
          var cubit = NavigationBarCubit.get(context);
          return Scaffold(
            body: AppRoutes.animeScreen,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
              title: NeuText(
                  text: "MAL",
                  fontSize: 35,
                  strokeWidth: 2,
                  color: navigation_bar_buttons_color),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
              },
              elevation: 10,
              backgroundColor: navigation_bar_buttons_color,
              shape: CircleBorder(),
              child: Icon(
                FontAwesomeIcons.gear,
                color: navigation_bar_color,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                itemCount: cubit.icons.length,
                tabBuilder: (index, isActive) {
                  return Icon(
                    cubit.icons[index],
                    size: isActive ? 25.w : 20.w,
                    color: isActive
                        ? navigation_bar_buttons_color
                        : Colors.grey[300],
                  );
                },
                activeIndex: cubit.current_index,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                backgroundColor: navigation_bar_color,
                leftCornerRadius: 12,
                shadow: Shadow(
                    offset: Offset(0, -0.1),
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.3)),
                rightCornerRadius: 12,
                onTap: (index) {
                  cubit.changePage(index);
                }),
          );
        },
      ),
    );
  }
}
