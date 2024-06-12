import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(BuildContext context) => BlocProvider.of(context);

  // Text Controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  // Validator
  final formKey = GlobalKey<FormState>();

  // Password Obscurity
  var obscured = true;
  
  void changeObscurity() {
    obscured=!obscured;
    emit(ChangeObscurityState());
  }
}
