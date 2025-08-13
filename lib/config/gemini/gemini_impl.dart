import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImpl {
  final Dio _http = Dio(BaseOptions(baseUrl: dotenv.env['ENDPOINT_API'] ?? ''));

  Future<String> getResponse(String prompt) async {
    try {
      final body = {'prompt': prompt};
      final response = await _http.post('/basic-prompt', data: body);
      return response.data;
    } catch (e) {
      print(e);
      throw Exception('Cant get response of Gemini.');
    }
  }

  Stream<String> getResponseStream(String prompt) async* {
    try {
      final body = {'prompt': prompt};
      final response = await _http.post(
        '/basic-prompt-stream',
        data: body,
        options: Options(responseType: ResponseType.stream),
      );
      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';
      await for (final chunk in stream) {
        final chunkStream = utf8.decode(chunk, allowMalformed: true);
        buffer += chunkStream;
        yield buffer;
      }
    } catch (e) {
      print(e);
      throw Exception('Cant get response of Gemini.');
    }
  }
}
