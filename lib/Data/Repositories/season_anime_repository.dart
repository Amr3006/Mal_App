import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/season_anime_service.dart';

class SeasonAnimeRepo {
  late SeasonAnimeService _seasonAnimeService;

  SeasonAnimeRepo() {
    _seasonAnimeService = SeasonAnimeService();
  }

  bool _nextPage = false;

  Future<List<AnimeModel>> getData(int page) async {
    final json = await _seasonAnimeService.get(page);
    final List<AnimeModel> data = [];
    final List<dynamic> list = json["data"];
    _nextPage = json["pagination"]["has_next_page"];
    for (var element in list) {
      data.add(AnimeModel.fromJson(element));
    }
    return data;
  }

  bool getPagination() {
    return _nextPage;
  }

}