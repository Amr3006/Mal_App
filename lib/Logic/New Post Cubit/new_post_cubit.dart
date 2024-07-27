import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

part 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostInitial());

  static NewPostCubit get(BuildContext context) => BlocProvider.of(context);

  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // Picking Image
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

  final List<String> imageNames = [];
  final List<XFile> pickedImages = [];
  final List<String> pickedImagesUrls = [];
  final List<AnimeModel> pickedAnimes= [];

  // Upload Picked Images
  Future<void> uploadImages() async {
    emit(LoadingUploadImagesState());
    try 
    {if (pickedImages.isEmpty) return;
    final futureUploads = pickedImages.map((image) {
      return _storage.ref().child("Posts/$uId/${image.name}").putFile(File(image.path));
    }).toList();
    final responses = await Future.wait(futureUploads);
    final futureUrls = responses.map((image) {
      return image.ref.getDownloadURL();
    }).toList();
    final urls = await Future.wait(futureUrls);
    pickedImagesUrls.addAll(urls);
    emit(SuccessUploadImagesState());
    }
    catch (e) {
      emit(FailedUploadImagesState(e.toString()));
    }
  }

  // Add Anime
  void addAnime(AnimeModel model) {
    pickedAnimes.add(model);
    emit(PickedAnimeState());
  }

  // Remove Anime
  void removeAnime(AnimeModel model) {
    pickedAnimes.remove(model);
    emit(RemovedAnimeState());
  }
}
