// ignore_for_file

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Episode%20Model.dart';
import 'package:mal_app/Data/Repositories/anime_details_repository.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'anime_details_state.dart';

class DetailedAnimeCubit extends Cubit<DetailedAnimeState> {
  DetailedAnimeCubit() : super(DetailedAnimeInitial());

  static DetailedAnimeCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final _firestore = FirebaseFirestore.instance;

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
    }
  }

  // Get Data
  final List<CharacterModel> characters = [];
  final List<EpisodeModel> episodes = [];
  bool gotEpisodes = false, gotCharacters = false;
  void setData() {
    characters.addAll(_repo.returnCharacters());
    episodes.addAll(_repo.returnEpisodes());
    gotCharacters = true;
    gotEpisodes = true;
  }

  // Add to recently opened
  void addToRecentlyOpened(AnimeModel model) async {
    try {
      final Map<String, dynamic> data = {"dateTime": DateTime.now().toString()};
      emit(LoadingUploadRecentState());
      data.addAll(model.toJson());
      await _firestore
          .collection("Users")
          .doc(uId)
          .collection("Recent")
          .doc(model.malId.toString())
          .set(data);
      emit(SuccessUploadRecentState());
    } catch (e) {
      emit(FailedUploadRecentState(e.toString()));
    }
  }

  // Add to favourites
  void changeFavourites(AnimeModel model) async {
    try {
      emit(LoadingFavouriteState());
      final favourites = publicUser!.favourites;
      if (favourites.contains(model.malId)) {
        publicUser!.favourites.remove(model.malId);
        await Future.wait([
         _firestore
            .collection("Users")
            .doc(uId)
            .collection("Favourites")
            .doc(model.malId.toString())
            .delete(),
            updateUser()
        ]);
      } else {
        publicUser!.favourites.add(model.malId);
        await Future.wait([
          updateUser(),
          _firestore
            .collection("Users")
            .doc(uId)
            .collection("Favourites")
            .doc(model.malId.toString())
            .set(model.toJson())
        ]);
      }
      emit(SuccessFavouriteState());
    } catch (e) {
      emit(FailedFavouriteState(e.toString()));
    }
  }

  Future<void> updateUser() {
    return _firestore
        .collection("Users")
        .doc(uId)
        .update(publicUser!.toJson());
  }
}
