import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class TopCharacterService {
  late final ApiHelper _apiHelper;
  static const _endPoint = "/top/characters";

  TopCharacterService () {
    _apiHelper = ApiHelper();
  }

  Future<Map<String,dynamic>> get() async {
    final respone = await _apiHelper.get(_endPoint);
    return jsonDecode(respone.toString());
  }
}