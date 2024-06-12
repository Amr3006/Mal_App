import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var obscured = true;

  void changeObscurity() {
    obscured=!obscured;
    emit(ChangeObscurtityState());
  }
}
