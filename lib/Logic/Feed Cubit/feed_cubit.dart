// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_field, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Repositories/season_anime_repository.dart';
import 'package:mal_app/Data/Repositories/top_anime_repository.dart';
import 'package:mal_app/Data/Repositories/top_character_repository.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'feed_state.dart';

// TODO: Remove the prints

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial());

  static FeedCubit get(BuildContext context) => BlocProvider.of(context);

  final _firestore = FirebaseFirestore.instance;

  var scrollController = ScrollController();

  // Initialize Scroll Listener
  void scrollListenerInit() {
    scrollController.addListener(() {
      {
        if (!_seasonAnimeRepo.returnPagination()) return;
        if (scrollController.position.extentAfter < 500 &&
            state is! LoadingSeasonAnimeState) {
          getSeasonAnimes();
        }
      }
    });
  }

  // Repositories
  final TopAnimeRepo _topAnimeRepo = TopAnimeRepo();
  final SeasonAnimeRepo _seasonAnimeRepo = SeasonAnimeRepo();
  final TopCharacterRepo _topCharacterRepo = TopCharacterRepo();

  // Top Animes
  final List<AnimeModel> topAnimes = [];
  Future<void> getTopAnimes() async {
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
  Future<void> getPopularCharacters() async {
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
  Future<void> getSeasonAnimes() async {
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

  // Recent
  final List<AnimeModel> recentAnimes = [];
  bool gotRecent = false;
  Future<void> getRecent() async {
    emit(LoadingRecentAnimesState());
    try{
    final data = await _firestore
    .collection("Users")
    .doc(uId)
    .collection("Recent")
    .orderBy("dateTime",descending: true)
    .get();
    final List<int> recentIds = [];
    for (int i=0;i<data.docs.length;i++) {
      final model = AnimeModel.fromJson(data.docs[i].data());
      if (recentIds.contains(model.malId)) continue;
      recentAnimes.add(model);
      recentIds.add(model.malId);
      if (recentAnimes.length >= 10) break;
    }
    gotRecent=true;
    emit(SuccessRecentAnimesState());
    } catch (e) {
      emit(FailedRecentAnimesState(e.toString()));
      print(e.toString());
    }
  }

  // Clear All lists
  void clear() {
    page=1;
    seasonAnimes.clear();
    topAnimes.clear();
    popularCharcters.clear();
    recentAnimes.clear();
  }
}
