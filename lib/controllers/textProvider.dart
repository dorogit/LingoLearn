import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lingolearn/apis/grammarApi.dart';

import '../apis/photoApi.dart';
import 'photoProvider.dart';

final textProvider = FutureProvider.autoDispose((ref) async {
  final photo = ref.watch(photoProvider);
  var text = await PhotoAPI().extract_text(File(photo.toString()));
  print(text);
  final response = await TextAPI().grammar_correction(text);
  print(response);
  return response;
});

// Provider to fetch the daily English task
final dailyEnglishTaskProvider =
    FutureProvider.autoDispose<String>((ref) async {
  const url = "https://api.ai21.com/studio/v1/j1-large/complete";
  const headers = {
    "Authorization": "Bearer YOUR_API_KEY", // Replace with your actual API Key
    "Content-Type": "application/json"
  };
  var data = jsonEncode({
    "prompt": "Write a simple English question about grammar:",
    "maxTokens": 30,
    "stopSequences": ["\n"],
    "temperature": 0.7
  });

  final response =
      await http.post(Uri.parse(url), headers: headers, body: data);
  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    return jsonData['completions'][0]['data']['text'] as String;
  } else {
    throw Exception('Failed to load daily task');
  }
});
