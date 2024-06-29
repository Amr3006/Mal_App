// ignore: unused_import
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Data/Models/Character%20Model.dart';
import 'package:mal_app/Data/Services/top_character_service.dart';

class TopCharacterRepo {
  late final TopCharacterService _service;

  TopCharacterRepo() {
    _service = TopCharacterService();
  }

  final List<CharacterModel> _data = [];

  Future<void> get() async {
    _data.clear();
    final json = await _service.get();
    final List<dynamic> list = json["data"];
    for (var element in list) {
      _data.add(CharacterModel.fromJson(element));
    }
  }

  List<CharacterModel> returnData() {
    return _data;
  }
}