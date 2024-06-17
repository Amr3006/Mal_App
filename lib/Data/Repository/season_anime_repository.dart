import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/season_anime_service.dart';

class SeasonAnimeRepo {
  late SeasonAnimeService _seasonAnimeService;

  SeasonAnimeRepo() {
    _seasonAnimeService = SeasonAnimeService();
  }

  Future<List<AnimeModel>> get() async {
    final response = await _seasonAnimeService.get();
    final List<AnimeModel> data = [];
    final List<dynamic> list = response["data"];
    for (var element in list) {
      data.add(AnimeModel.fromJson(element));
    }
    return data;
  }
}