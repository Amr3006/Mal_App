// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Repositories/anime_search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(BuildContext context) => BlocProvider.of(context);

  final scrollController = ScrollController();
  final searchController = TextEditingController();

  void initializeScrollListener() {
    scrollController.addListener(() {
      if (!_repo.returnPagination()) return;
      if (scrollController.position.extentAfter < 500 &&
          state is! LoadingMoreDataState) {
        loadMoredata(searchController.text);
      }
    });
  }

  final _repo = AnimeSearchRepo();
  final List<AnimeModel> results = [];
  bool gotSearch = false;

  Future<void> getData() async {
    gotSearch=false;
    results.clear();
    try {
      emit(LoadingDataState());
      await _repo.getData(searchController.text);
      results.addAll(_repo.returnData());
      gotSearch=true;
      emit(SuccessDataState());
    } catch (e) {
      emit(FailedDataState(e.toString()));
      print(e.toString());
    }

  }

  int page = 2;
  void loadMoredata(String q) async {
    try {
      emit(LoadingMoreDataState());
      await _repo.getData(q, page: page);
      results.addAll(_repo.returnData());
      emit(SuccessMoreDataState());
      page++;
    } catch (e) {
      emit(FailedMoreDataState(e.toString()));
      print(e.toString());
    }
  }
}
