import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/season_anime_service.dart';

class SeasonAnimeRepo {
  late SeasonAnimeService _seasonAnimeService;

  SeasonAnimeRepo() {
    _seasonAnimeService = SeasonAnimeService();
  }

  bool _nextPage = false;
  final List<AnimeModel> _data = [];

  Future<void> get(int page) async {
    _data.clear();
    final json = await _seasonAnimeService.get(page);
    final List<dynamic> list = json["data"];
    _nextPage = json["pagination"]["has_next_page"];
    for (var element in list) {
      _data.add(AnimeModel.fromJson(element));
    }
  }

  List<AnimeModel> returnData() {
    return _data;
  }

  bool returnPagination() {
    return _nextPage;
  }

}