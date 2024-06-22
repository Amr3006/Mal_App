import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Services/top_anime_service.dart';

class TopAnimeRepo {
  late final TopAnimeService _service;

  TopAnimeRepo() {
    _service=TopAnimeService();
  }

  final List<AnimeModel> _data = [];

  Future<void> get() async {
    _data.clear();
    final json = await _service.get();
    final List<dynamic> list = json["data"];
    for (var element in list) {
      _data.add(AnimeModel.fromJson(element));
    }
  }

  List<AnimeModel> returnData() {
   return _data; 
  }
}