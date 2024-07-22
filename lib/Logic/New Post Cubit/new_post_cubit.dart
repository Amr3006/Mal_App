import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostInitial());

  static NewPostCubit get(BuildContext context) => BlocProvider.of(context);

}
