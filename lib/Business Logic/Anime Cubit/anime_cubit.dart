// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Repository/season_anime_repository.dart';
import 'package:mal_app/Data/Repository/top_anime_repositore.dart';

part 'anime_state.dart';

class AnimeCubit extends Cubit<AnimeState> {
  AnimeCubit() : super(AnimeInitial());

  static AnimeCubit get(BuildContext context) => BlocProvider.of(context);

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
    }
  }

  // Currenct Animes
  final List<AnimeModel> seasonAnimes = [];
  void getSeasonAnimes() async {
    emit(LoadingSeasonAnimeState());
    try {
      final _temp = await _seasonAnimeRepo.get();
      seasonAnimes.addAll(_temp);
      emit(SuccessSeasonAnimeState());
    } catch (e) {
      emit(FailedSeasonAnimeState(e.toString()));
    }
  }

}
