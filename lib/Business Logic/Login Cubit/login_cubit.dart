import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  // Text Controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Form Key
  var formKey = GlobalKey<FormState>();

  // Change Password Obscurity
  var obscured = true;

  void changeObscurity() {
    obscured = !obscured;
    emit(ChangeObscurtityState());
  }

  // Sign in with e-mail and password
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> loginWithEmailAndPassword() async {
    emit(LoadingLoginWithEmailAndPasswordState());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      bool saved = await saveuId(userCredential.user!);
      if (!saved) {
        throw "uId not saved";
      }
      emit(SuccessLoginWithEmailAndPasswordState());
    } on FirebaseAuthException catch (e) {
      emit(FailedLoginWithEmailAndPasswordState(e.code));
    }
  }

  // Save uId
  Future<bool> saveuId(User user) async {
    uId = user.uid;
    return await CacheHelper.saveData("uId", user.uid);
  }
}
