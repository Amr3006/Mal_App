import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Services/top_character_service.dart';

class TopCharacterRepo {
  late final TopCharacterService _topCharacterService;

  TopCharacterRepo() {
    _topCharacterService = TopCharacterService();
  }

  Future<List<CharacterModel>> get() async {
    final json = await _topCharacterService.get();
    final List<CharacterModel> data = [];
    final List<Map<String,dynamic>> list = json["data"];
    for (var element in list) {
      data.add(CharacterModel.fromJson(element));
    }
    return data;
  }
}