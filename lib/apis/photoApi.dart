import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PhotoAPI {
  final _client = http.Client();
  extract_text(File file) async {
    print(file.path.split('/').last);
    final multipartFile = http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: file.path.split('/').last);
    final request = http.MultipartRequest('POST',
        Uri.parse('https://improveng-backend.onrender.com/extract_text'))
      ..files.add(multipartFile);

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);
    print(response.reasonPhrase);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Handle the JSON data
      print((jsonData['text']).join(' '));
      return (jsonData['text']).join(' ');
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
    }
    // return (jsonDecode(response.stream.)['text']).join('');
  }
}
