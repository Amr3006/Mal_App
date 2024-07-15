import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class RandomAnimeService {
  late final ApiHelper _apiHelper;
  static const endPoint = "/random/anime";

  RandomAnimeService() {
    _apiHelper=ApiHelper();
  }

  Future<dynamic> get() async {
    final data = await _apiHelper.get(endPoint);
    return jsonDecode(data.toString());
  }
}