import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'anime_state.dart';

class AnimeCubit extends Cubit<AnimeState> {
  AnimeCubit() : super(AnimeInitial());

  static AnimeCubit get(BuildContext context) => BlocProvider.of(context);
}
