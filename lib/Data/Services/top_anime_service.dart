import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class TopAnimeService {
  static const _endPoint = "/top/anime";
  late ApiHelper _apiHelper;

  TopAnimeService() {
    _apiHelper = ApiHelper();
  }

  Future<dynamic> get() async {
    final response = await _apiHelper.get(_endPoint);
    return jsonDecode(response.toString());
  }
}