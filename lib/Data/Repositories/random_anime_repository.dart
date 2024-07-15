import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/random_anime_service.dart';

class RandomAnimeRepo {
  late final RandomAnimeService _service;

  RandomAnimeRepo() {
    _service = RandomAnimeService();
  }

  late AnimeModel _data;

  Future<void> getData() async {
    final json = await _service.get();
    _data = AnimeModel.fromJson(json["data"]);
  }

  AnimeModel returnData() => _data;
}