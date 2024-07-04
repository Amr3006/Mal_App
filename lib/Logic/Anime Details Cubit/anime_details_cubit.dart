// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Episode%20Model.dart';
import 'package:mal_app/Data/Repositories/anime_details_repository.dart';

part 'anime_details_state.dart';

// TODO: Remove the Prints

class DetailedAnimeCubit extends Cubit<DetailedAnimeState> {
  DetailedAnimeCubit() : super(DetailedAnimeInitial());

  static DetailedAnimeCubit get(BuildContext context) => BlocProvider.of(context);


  // Repo
  late final DetailedAnimeRepo _repo;

  // Save Data to Repo
  void getData(int id) async {
    emit(LoadingDataState());
    try {
    _repo = DetailedAnimeRepo(id);
    await Future.wait([_repo.getCharacters(), _repo.getEpisodes()]);
    setData();
    emit(SuccessDataState());
    } catch (e) {
      emit(FailedDataState(e.toString()));
      print(e.toString());
    }
  }

  // Get Data 
  final List<CharacterModel> characters = [];
  final List<EpisodeModel> episodes = [];
  bool gotEpisodes = false, gotCharacters = false;
  void setData() {
    characters.addAll(_repo.returnCharacters());
    episodes.addAll(_repo.returnEpisodes());
    gotCharacters=true;
    gotEpisodes=true;
  }
}
