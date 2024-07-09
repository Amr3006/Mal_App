import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Data/Services/authentication.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  final AppAuthentication _auth = AppAuthentication();

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

  // Sign in with Google
  void loginWithGoogle() async {
    try {
      emit(LoadingLoginWithGoogleState());
      final user = await _auth.loginWithGoogle();
      final model = UserModel(
        name: user!.displayName ?? "", 
        favourites: [], 
        email: user.email ?? "", 
        phone: user.phoneNumber ?? "", 
        profilePicture: user.photoURL ?? "https://wallpapers-clan.com/wp-content/uploads/2023/01/anime-aesthetic-boy-pfp-1.jpg", 
        uId: user.uid); 
        await _auth.createUser(user,model);
      emit(SuccessLoginWithGoogleState());
    } catch (e) {
      emit(FailedLoginWithGoogleState(e.toString()));
    }
  } 

  // Sign in with e-mail and password
  Future<void> loginWithEmailAndPassword() async {
    emit(LoadingLoginWithEmailAndPasswordState());
    await _auth.loginWithEmail(emailController.text, passwordController.text);
    try {
      emit(SuccessLoginWithEmailAndPasswordState());
    } on FirebaseAuthException catch (e) {
      emit(FailedLoginWithEmailAndPasswordState(e.code));
    }
  }

  
}
