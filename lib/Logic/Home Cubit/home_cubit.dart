// ignore_for_file

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Repositories/random_anime_repository.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';


part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  final _repo = RandomAnimeRepo();

  bool isCommunity = false;
  
  List<Widget> screens = [
    AppRoutes.animeScreen,
    AppRoutes.profileScreen
  ];

  void changeMode() {
    isCommunity = !isCommunity;
    if (!isCommunity) {
      screens = [
        AppRoutes.animeScreen, 
        AppRoutes.profileScreen
      ];
    } else {
      screens = [
        AppRoutes.communityScreen,
        AppRoutes.profileScreen
      ];
    }
    emit(ChangeModeState());
  }

  int current_index = 0;
  void changePage(int index) {
    current_index=index;
    emit(ChangeNavigationBarPageState());
  }

  AnimeModel? randomAnime;
  // Random Anime
  Future<void> getRandomAnime() async {
    try {
      emit(LoadingRandomAnimeState());
      await _repo.getData();
      randomAnime = _repo.returnData();
      emit(SucceedRandomAnimeState());
    } catch (e) {
      emit(FailedRandomAnimeState(e.toString()));
    }
  }
}
