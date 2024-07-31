import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Post%20Model.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(CommunityInitial());

  static CommunityCubit get(BuildContext context) => BlocProvider.of(context);

  final _firestore = FirebaseFirestore.instance;

  final List<String> postIDs = [];
  final Map<String, PostModel> posts = {};

  Future<void> getPosts() async {
    emit(LoadingPostsState());
    try {
    final queries = await _firestore.collection("Posts").get();
    final docs = queries.docs;
    final futures = docs.map((doc) {
      postIDs.add(doc.id);
      return getPostAnimes(doc);
    }).toList();
    await Future.wait(futures);
    emit(SuccessPostsState());
    } catch (e) {
      emit(FailedPostsState(e.toString()));
    }
  }

  Future<void> getPostAnimes(QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final post = PostModel.fromJson(doc.data());
    final queries = await _firestore.collection("Posts").doc(doc.id).collection("Animes").get();
    final docs = queries.docs;
    List<AnimeModel> temp= [];
    for (var anime in docs) {
      temp.add(AnimeModel.fromJson(anime.data()));
    }
    post.animes = temp.toList();
    posts[doc.id] = post;
  }
}
