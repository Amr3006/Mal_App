// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_field, avoid_print

// ignore: unused_import
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Repositories/season_anime_repository.dart';
import 'package:mal_app/Data/Repositories/top_anime_repository.dart';
import 'package:mal_app/Data/Repositories/top_character_repository.dart';

part 'feed_state.dart';

// TODO: Remove the prints

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial()); 

  static FeedCubit get(BuildContext context) => BlocProvider.of(context);

  var scrollController = ScrollController();


  // Initialize Scroll Listener
  void scrollListenerInit() {
    scrollController.addListener(scrollListener);
  }

  // Scroll Listener
  void scrollListener() {
    if (!_seasonAnimeRepo.returnPagination()) {
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
  final TopCharacterRepo _topCharacterRepo = TopCharacterRepo();

  // Top Animes
  final List<AnimeModel> topAnimes = [];
  void getTopAnimes() async {
    emit(LoadingTopAnimeState());
    try {
      await _topAnimeRepo.get();
      final _temp = _topAnimeRepo.returnData();
      topAnimes.addAll(_temp);
      emit(SuccessTopAnimeState());
    } catch (e) {
      emit(FailedTopAnimeState(e.toString()));
      print(e.toString());
    }
  }

  // Popular Characters
  final List<CharacterModel> popularCharcters = [];
  void getPopularCharacters() async {
    emit(LoadingPopularCharactersState());
    try {
      await _topCharacterRepo.get();
      final _temp = _topCharacterRepo.returnData();
      popularCharcters.addAll(_temp);
      emit(SuccessPopularCharactersState());
    } catch (e) {
      emit(FailedPopularCharactersState(e.toString()));
      print(e.toString());
    }
  }

  // Currenct Animes
  int page = 1;
  final List<AnimeModel> seasonAnimes = [];
  void getSeasonAnimes() async {
    emit(LoadingSeasonAnimeState());
    try {
      await _seasonAnimeRepo.get(page);
      var _temp = _seasonAnimeRepo.returnData();
      seasonAnimes.addAll(_temp);
      page++;
      emit(SuccessSeasonAnimeState());
    } catch (e) {
      emit(FailedSeasonAnimeState(e.toString()));
      print(e.toString());
    }
  }
}


