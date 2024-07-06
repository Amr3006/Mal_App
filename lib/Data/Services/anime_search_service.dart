import 'dart:convert';

import 'package:mal_app/Data/API/API%20Helper.dart';

class AnimeSearchService {
  late final ApiHelper _apiHelper;
  static const endPoint = '/anime';

  AnimeSearchService() {
    _apiHelper = ApiHelper();
  }

  Future<dynamic> get(String q, int page) async {
    final response = await _apiHelper.get(endPoint, queryParamters: {"q" : q, "page" : page});
    return jsonDecode(response.toString());
  }

}