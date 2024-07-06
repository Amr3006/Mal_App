import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/anime_search_service.dart';

class AnimeSearchRepo {
  late final AnimeSearchService _service;

  AnimeSearchRepo() {
    _service = AnimeSearchService();
  }

  late final List<AnimeModel> _list = [];
  bool _nextPage = false;

  Future<void> getData(String q, {int page = 1}) async {
    _list.clear();
    final json = await _service.get(q, page);
    final List<dynamic> data = json["data"];
    _nextPage = json["pagination"]["has_next_page"];
    for (var element in data) {
      _list.add(AnimeModel.fromJson(element));
    }
    return;
  }

  List<AnimeModel> returnData() {
    return _list;
  }

  bool returnPagination() {
    return _nextPage;
  }
}