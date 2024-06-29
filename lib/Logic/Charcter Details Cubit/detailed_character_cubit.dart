// ignore_for_file: avoid_print

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Detailed%20Character%20Model.dart';
import 'package:mal_app/Data/Repositories/character_details_repository.dart';
import 'package:meta/meta.dart';

part 'detailed_character_state.dart';

// TODO: Remove Prints

class DetailedCharacterCubit extends Cubit<DetailedCharacterState> {
  DetailedCharacterCubit() : super(DetailedCharacterInitial());

  static DetailedCharacterCubit get(BuildContext context) => BlocProvider.of(context);

  late final DetailedCharacterRepo _repo;
  late final DetailedCharacterModel model;

  Future<void> getCharacter(int id) async {
    try {
      emit(LoadingCharacterDetailsState());
      _repo = DetailedCharacterRepo(id);
      await _repo.getData();
      model = _repo.returnData();
      emit(SuccessCharacterDetailsState());
    } catch (e) {
      emit(FailedCharacterDetailsState(e.toString()));
      print(e.toString());
    }
  }
}
