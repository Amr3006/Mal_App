import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/top_anime_service.dart';

class TopAnimeRepo {
  late final TopAnimeService _service;

  TopAnimeRepo() {
    _service=TopAnimeService();
  }

  Future<List<AnimeModel>> get() async {
    final response = await _service.get();
    final List<AnimeModel> data=[];
    final List<dynamic> list = response["data"];
    for (var element in list) {
      data.add(AnimeModel.fromJson(element));
    }
    return data;
  }
}