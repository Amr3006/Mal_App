import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class DetailedCharacterService {
  final int id;
  late final ApiHelper _apiHelper; 

  DetailedCharacterService(this.id) {
    _apiHelper = ApiHelper();
  }

  Future<dynamic> get() async {
    final respone = await _apiHelper.get("/characters/$id");
    return jsonDecode(respone.toString());
  }
}