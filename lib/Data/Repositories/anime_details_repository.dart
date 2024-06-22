import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Models/Episode%20Model.dart';
import 'package:mal_app/Data/Services/anime_details_service.dart';

class DetailedAnimeRepo {
  late final DetailedAnimeService _animeDetailsService;
  final int id;

  final List<EpisodeModel> _episodesList = [];
  final List<CharacterModel> _charactersList = [];

  DetailedAnimeRepo(this.id) {
    _animeDetailsService = DetailedAnimeService(id);
  }

  Future<void> getCharacters() async {
    _charactersList.clear();
    final json = await _animeDetailsService.getCharacters();
    final List<dynamic> list = json["data"];
    for (var element in list) {
      _charactersList.add(CharacterModel.fromJson(element["character"]));
    }
  }

  Future<void> getEpisodes() async {
    _episodesList.clear();
    final json = await _animeDetailsService.getEpisodes();
    final List<dynamic> list = json["data"];
    for (var element in list) {
      _episodesList.add(EpisodeModel.fromJson(element)); 
    }
  }

  List<CharacterModel> returnCharacters() {
    return _charactersList;
  }

  List<EpisodeModel> returnEpisodes() {
    return _episodesList;
  }
}
