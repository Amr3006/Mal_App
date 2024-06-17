import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(BuildContext context) => BlocProvider.of(context);

  // Text Controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        name: nameController.text, 
        email: emailController.text, 
        phone: phoneController.text, 
        profilePicture: "https://wallpapers-clan.com/wp-content/uploads/2023/01/anime-aesthetic-boy-pfp-1.jpg", 
        uId: user!.uid);
      emit(LoadingCreateUserWithEmailAndPasswordState());
    try {
      await _firestore
      .collection("Users")
      .doc(user.uid)
      .set(userModel.toJson());
      bool saved = await saveuId(user);
      if (!saved) {
        throw "uId not Saved" ;
      }
      emit(SuccessCreateUserWithEmailAndPasswordState());
      dispose();
    } catch (e) {
      emit(FailedCreateUserWithEmailAndPasswordState(e.toString()));
    }
  }

  // Save uId
  Future<bool> saveuId(User user) async {
    uId = user.uid;
    return await CacheHelper.saveData("uId", user.uid);
  }

  // Sign Up with email and password
  Future<User?> signUpWithEmailAndPassword() async {
    try {
    emit(LoadingSignUpWithEmailAndPasswordState());
    final UserCredential userCredentials = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    emit(SuccessSignUpWithEmailAndPasswordState());
    return userCredentials.user;
    } on FirebaseAuthException catch (e) {
      emit(FailedSignUpWithEmailAndPasswordState(e.code));
    }
    return null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }
}
