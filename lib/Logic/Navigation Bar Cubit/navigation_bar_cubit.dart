// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';


part 'navigation_bar_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit() : super(NavigationBarInitial());

  static NavigationBarCubit get(BuildContext context) => BlocProvider.of(context);

  List<IconData> icons = [
      FontAwesomeIcons.tv,
      Icons.person_rounded,
    ];
  
  List<Widget> screen = [
    AppRoutes.animeScreen,
    AppRoutes.profileScreen
  ];

  int current_index = 0;
  void changePage(int index) {
    current_index=index;
    emit(ChangeNavigationBarPageState());
  }
}
