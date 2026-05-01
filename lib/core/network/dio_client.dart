import 'package:dio/dio.dart';

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _dio.post<dynamic>(path, data: body);
  }
}
