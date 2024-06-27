import 'dart:convert';

// ignore: unused_import
import 'package:dio/dio.dart';
import 'package:mal_app/Data/API/API%20Helper.dart';

class DetailedAnimeService {
  late final ApiHelper _apiHelper;
  final int id;

  DetailedAnimeService(this.id) {
    _apiHelper = ApiHelper();
  }

  Future<dynamic> getCharacters() async {
    final respone = await _apiHelper.get("/anime/$id/characters");
    return jsonDecode(respone.toString());
  }

  Future<dynamic> getEpisodes() async {
    final response = await _apiHelper.get("/anime/$id/episodes");
    return jsonDecode(response.toString());
  }
}