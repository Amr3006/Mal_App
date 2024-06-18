import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class SeasonAnimeService {
  static const String _endPoint = "/seasons/now";
  late ApiHelper _apiHelper;

  SeasonAnimeService() {
    _apiHelper = ApiHelper();
  }

  Future<Map<String,dynamic>> get(int page) async {
    final respone = await _apiHelper.get(_endPoint, queryParamters: {"page" : page});
    return jsonDecode(respone.toString());
  }
}