// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

class ApiHelper {
  static late Dio _dio;

  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl
      )
    );}

  Future<Response> get(
    String path
  ) async {
    return await _dio.get(path);
  }
}