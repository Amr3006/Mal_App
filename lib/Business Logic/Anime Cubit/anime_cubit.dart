// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Repositories/season_anime_repository.dart';
import 'package:mal_app/Data/Repositories/top_anime_repositore.dart';

part 'anime_state.dart';

class AnimeCubit extends Cubit<AnimeState> {
  AnimeCubit() : super(AnimeInitial());

  static AnimeCubit get(BuildContext context) => BlocProvider.of(context);

  var scrollController = ScrollController();

  // Initialize Scroll Listener
  void scrollListenerInit() {
    scrollController.addListener(scrollListener);
  }

  // Scroll Listener
  void scrollListener() {
    if (!_seasonAnimeRepo.getPagination()) {
      return;
    }
    if (scrollController.position.extentAfter.h < 500.h &&
        state is! LoadingSeasonAnimeState) {
      getSeasonAnimes();
    }
  }

  // Repositories
  final TopAnimeRepo _topAnimeRepo = TopAnimeRepo();
  final SeasonAnimeRepo _seasonAnimeRepo = SeasonAnimeRepo();

  // Top Animes
  final List<AnimeModel> topAnimes = [];
  void getTopAnimes() async {
    emit(LoadingTopAnimeState());
    try {
      final _temp = await _topAnimeRepo.get();
      topAnimes.addAll(_temp);
      emit(SuccessTopAnimeState());
    } catch (e) {
      emit(FailedTopAnimeState(e.toString()));
      print(e.toString());
    }
  }

  // Currenct Animes
  int page = 1;
  final List<AnimeModel> seasonAnimes = [];
  void getSeasonAnimes() async {
    emit(LoadingSeasonAnimeState());
    try {
      var _temp = await _seasonAnimeRepo.get(page);
      seasonAnimes.addAll(_temp);
      page++;
      emit(SuccessSeasonAnimeState());
    } catch (e) {
      emit(FailedSeasonAnimeState(e.toString()));
      print(e.toString());
    }
  }
}
