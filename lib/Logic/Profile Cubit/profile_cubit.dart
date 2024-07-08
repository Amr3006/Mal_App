// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'profile_state.dart';

// Todo remove prints

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static ProfileCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? user,backupUser;

  final textController = TextEditingController();

  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var enabled = false;

  // Get User Data
  Future<void> getUser() async {
    emit(LoadingGetUserState());
    try {
    final unmodeledData = await firestore
    .collection("Users")
    .doc(uId)
    .get();
    user = UserModel.fromJson(unmodeledData.data()!);
    backupUser = user!.clone();
    publicUser=user;
    publicBackUpUser = backupUser;
    emit(SuccessGetUserState());
    } catch (e) {
      print(e.toString());
      emit(FailedGetUserState(e.toString()));
    }
  }

  // Update User
  Future<void> updateUser() async {
    try {
    await _firestore
    .collection("Users")
    .doc(user!.uId)
    .update(user!.toJson());
    backupUser = user!.clone();
    return;
    } catch (e) {
      user = backupUser!.clone();
      throw "Error updating user: ${e.toString()}";
    }
  }

  // Change Profile Picture
  Future<XFile?> pickImage() async {
    emit(PickingImageState());
    final imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  void changeImage() async {
    final image = await pickImage();
    if (image == null) return;
    emit(LoadingChangeProfilePictureState());
    try {
      // Upload to Storage
      final file = await _storage
      .ref()
      .child("${user!.uId}/${image.name}")
      .putFile(File(image.path));

      // Get Url
      final url = await file.ref.getDownloadURL();
      user!.profilePicture=url;

      // Upload to Firestore
      await updateUser();
      emit(SuccessChangeProfilePictureState());
    } catch (e) {
      emit(FailedChangeProfilePictureState(e.toString()));
      print(e.toString());
    }
  }

  // Edit Name
  void changeEditMode() {
    enabled = !enabled;
    emit(ChangeEditModeState());
  }

  void changeName() async {
    if (textController.text == user!.name) {changeEditMode();
    return;}
    emit(LoadingChangeNameState());
    user!.name = textController.text;
    try {
      await updateUser();
      emit(SuccessChangeNameState());
    } catch (e) {
      emit(FailedChangeNameState(e.toString()));
      print(e.toString());
    }
    changeEditMode();
  }

  void logout() async {
    try {
      await _auth.signOut();
      final answer = await CacheHelper.deleteData('uId');
    if (answer) {
      emit(SuccessLogoutState());
    } else {
      emit(FailedLogoutState());
    }
    }
    catch (e) {
      emit(FailedLogoutState());
    }
  }
}
