import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingolearn/apis/grammarApi.dart';
import 'package:lingolearn/views/grammar.dart';

import '../apis/photoApi.dart';
import 'photoProvider.dart';

final grammarProvider = FutureProvider.autoDispose((ref) async {
  final photo = ref.watch(photoProvider);
  var text = await PhotoAPI().extract_text(File(photo.toString()));
  print(text);
  final response = await TextAPI().grammar_correction(text);
  print(response);
  return response;
});
