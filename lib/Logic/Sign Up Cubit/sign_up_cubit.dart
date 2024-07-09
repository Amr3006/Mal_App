import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Data/Services/authentication.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(BuildContext context) => BlocProvider.of(context);

  // Text Controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  final _auth = AppAuthentication();

  // Validator
  final formKey = GlobalKey<FormState>();

  // Password Obscurity
  var obscured = true;
  
  void changeObscurity() {
    obscured=!obscured;
    emit(ChangeObscurityState());
  }

  // Create User in FireStore
  Future<void> createUser() async {
      final user = await signUpWithEmailAndPassword();
      final userModel = UserModel(
        favourites: [],
        name: nameController.text, 
        email: emailController.text, 
        phone: phoneController.text, 
        profilePicture: "https://wallpapers-clan.com/wp-content/uploads/2023/01/anime-aesthetic-boy-pfp-1.jpg", 
        uId: user!.uid);
      await _auth.createUser(user, userModel);
      emit(LoadingCreateUserWithEmailAndPasswordState());
    try {
      emit(SuccessCreateUserWithEmailAndPasswordState());
    } catch (e) {
      emit(FailedCreateUserWithEmailAndPasswordState(e.toString()));
    }
  }
  // Sign Up with email and password
  Future<User?> signUpWithEmailAndPassword() async {
    try {
    emit(LoadingSignUpWithEmailAndPasswordState());
    emit(SuccessSignUpWithEmailAndPasswordState());
    return await _auth.signUpWithEmail(emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      emit(FailedSignUpWithEmailAndPasswordState(e.code));
    }
    return null;
  }
}
