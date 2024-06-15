import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static UserCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? user;

  // Get User Data
  Future<void> getUser() async {
    emit(LoadingGetUserState());
    try {
    final unmodeledData = await firestore
    .collection("Users")
    .doc(uId)
    .get();
    user = UserModel.fromJson(unmodeledData.data()!);
    emit(SuccessGetUserState());
    } catch (e) {
      emit(FailedGetUserState(e.toString()));
    }
  }
}
