import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Post%20Model.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostInitial());

  static NewPostCubit get(BuildContext context) => BlocProvider.of(context);

  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  final List<String> imageNames = [];
  final List<XFile> pickedImages = [];

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

  // Picking an Image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final list = await picker.pickMultiImage();
    for (var file in list) {
      if (imageNames.contains(file.name)) continue;
      pickedImages.add(file);
      imageNames.add(file.name);
    }
    emit(PickedImagesState());
  }

  // Removing an Image
  void removeImage(XFile file) {
    pickedImages.remove(file);
    imageNames.remove(file.name);
    emit(RemovedImageState());
  }

  // Upload Picked Images
  Future<List<String>> uploadImages() async {
    if (pickedImages.isEmpty) return [];
    emit(LoadingUploadImagesState());
    try {
    final futureUploads = pickedImages.map((image) {
      return _storage.ref().child("Posts/$uId/${image.name}").putFile(File(image.path));
    }).toList();
    final responses = await Future.wait(futureUploads);
    final futureUrls = responses.map((image) {
      return image.ref.getDownloadURL();
    }).toList();
    final urls = await Future.wait(futureUrls);
    emit(SuccessUploadImagesState());
    return urls;
    }
    catch (e) {
      emit(FailedUploadImagesState(e.toString()));
    }
    return [];
  }

  final List<AnimeModel> pickedAnimes= [];

  // Add Anime
  void addAnime(AnimeModel model) {
    pickedAnimes.add(model);
    emit(AddedAnimeState());
  }

  // Remove Anime
  void removeAnime(AnimeModel model) {
    pickedAnimes.remove(model);
    emit(RemovedAnimeState());
  }

  //Upload Animes
  Future<void> uploadAnimes(String docId) async {
    if (pickedAnimes.isEmpty) return;
    emit(LoadingUploadAnimesState());
    try {
      final futureUploads = pickedAnimes.map((anime) {
        return _firestore.collection("Posts").doc(docId).collection("Animes").add(anime.toJson());
      }).toList();
      await Future.wait(futureUploads);
      emit(SuccessUploadAnimesState());
    } catch (e) {
      emit(FailedUploadAnimesState(e.toString()));
    }
  }

  bool uploadingPost = false;

  // Post
  void post(String text) async {
    uploadingPost = true; 
    emit(LoadingUploadPostState());   
    try {final urls = await uploadImages();
    final data = PostModel(
      userName: user!.name, 
      userProfilePic: user!.profilePicture, 
      postText: text, 
      dateTime: DateTime.now().toString(), 
      images: urls);
    final document = await _firestore.collection("Posts").add(data.toJson());
    final query = await document.get();
    user!.postIDs.add(query.id);
    await Future.wait([
      uploadAnimes(query.id),
      updateUser()
    ]);
    emit(SuccessUploadPostState());    
    } catch (e) {
      emit(FailedUploadPostState(e.toString()));    
    }
    uploadingPost = false;
  }
}
