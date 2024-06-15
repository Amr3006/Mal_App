import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class TopAnimeService {
  final endPoint = "/top/anime";
  late ApiHelper _apiHelper;

  TopAnimeService() {
    ApiHelper.init();
    _apiHelper = ApiHelper();
  }

  Future<dynamic> get() async {
    final response = await _apiHelper.get(endPoint);
    return jsonDecode(response.toString());
  }
}