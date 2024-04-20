import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lingolearn/apis/photoApi.dart';

// final pastEssayProvider = StateProvider((ref) async {});
final pastEssayProvider = NotifierProvider<PastEssayNotifier, Future<Map>>(() {
  return PastEssayNotifier();
});

class PastEssayNotifier extends Notifier<Future<Map>> {
  @override
  Future<Map> build() async {
    var box = await Hive.openBox('essays');
    print('map ${box.toMap()}');
    return box.toMap();
  }

  addEssay(essayMap, len) async {
    final k = await state;
    k.update(len, (value) => essayMap, ifAbsent: () => essayMap);
  }
}
