import 'package:dio/dio.dart';

class HttpService {
  HttpService();

  final dio = Dio();

  Future<Response> fetchData(String url) async {
    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
