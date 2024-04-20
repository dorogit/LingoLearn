import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lingolearn/constants.dart';

class TextAPI {
  final _client = http.Client();
  grammar_correction(String text) async {
    // print(text);
    // print(text.runtimeType);
    final response = await _client.get(Uri.parse("$host/grammar?text=$text"));
    switch (response.statusCode) {
      case 200:
        return {
          'text': text,
          'errors': jsonDecode(response.body)['corrections'] ?? []
        };
      default:
        // print(response.body);
        return 'Error';
    }
  }

  text_improvement(String text) async {
    final response =
        await _client.get(Uri.parse("$host/text-improvements?text=$text"));
    print(response.body);
    switch (response.statusCode) {
      case 200:
        return {
          'text': text,
          'errors': jsonDecode(response.body)['improvements']
        };
      default:
        // print(response.body);
        return 'Error';
    }
  }
}
