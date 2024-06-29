import 'package:mal_app/Data/Models/Detailed%20Character%20Model.dart';
import 'package:mal_app/Data/Services/character_details_service.dart';

class DetailedCharacterRepo {
  late final DetailedCharacterService _service;
  final int id;

  DetailedCharacterRepo(this.id) {
    _service = DetailedCharacterService(id);
  }

  late final DetailedCharacterModel _model;

  Future<void> getData() async {
    final json = await _service.get();
    _model = DetailedCharacterModel.fromJson(json["data"]);
  }

  DetailedCharacterModel returnData() {
    return _model;
  }
}