import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lingolearn/controllers/grammarProvider.dart';
import 'package:lingolearn/views/text_improvements.dart';

class Grammar extends ConsumerWidget {
  Grammar({super.key});

  String ctext = '';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grammar = ref.watch(grammarProvider);
    print(grammar);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              'Grammar correction',
              textScaler: TextScaler.linear(1.4),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SliverList.list(
            children: [
              grammar.when(
                  data: (value) {
                    // List errors = value['errors'];
                    // List starts = [];
                    // List ends = [];
                    // String text = value['text'];
                    // for (final e in errors) {
                    //   text = text.replaceRange(e['startIndex'], e['endIndex'], e['suggestion']);
                    // }
                    // List texts = text.split('');
                    // print(texts);
                    // // return Text('loloolo');
                    // int index = 0;
                    // int errorsIdx = 0;
                    print("$value HEREROKAOKFKSODKFOCAKMOAKMCOFKMA");
                    List errors = value['errors'];

                    List<dynamic> texts = value['text'].split('');

                    List<InlineSpan>? textSpans = texts.map<InlineSpan>((e) {
                      return TextSpan(
                          text: e,
                          style: Theme.of(context).textTheme.titleLarge!);
                    }).toList();
                    for (final e in errors.reversed) {
                      textSpans.replaceRange(e['startIndex'], e['endIndex'], [
                        WidgetSpan(
                          child: InkWell(
                              onTap: () => errorDialog(context, e),
                              child: Card(
                                  color: const Color.fromARGB(2, 167, 186, 255),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                    child: Text(
                                      e['suggestion'],
                                      textScaler: const TextScaler.linear(1.2),
                                    ),
                                  ))),
                        )
                      ]);
                    }
                    String correctText = value['text'];

                    for (final e in errors.reversed) {
                      correctText = correctText.replaceRange(
                          e['startIndex'], e['endIndex'], e['suggestion']);
                    }
                    ctext = correctText;
                    print(ctext);
                    Hive.openBox('essays').then(
                        (Box essayBox) => essayBox.add({'grammar': errors}));

                    // return Text('loloolo');

                    // print('lol');
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text.rich(TextSpan(
                            children: textSpans,
                            //texts.map<InlineSpan>((e) {
                            // index += 1;
                            // if (starts.contains(index)) {
                            //   starts.removeAt(errorsIdx);
                            //   texts.removeRange(index, ends[errorsIdx]);
                            //   errorsIdx += 1;
                            //   print(errorsIdx);
                            //   return TextSpan(text: errors[errorsIdx-1]['suggestion']);
                            // } else {
                            // return TextSpan(text: e);
                            // }
                            // }).toList()
                          )),
                        ),
                      ],
                    );
                  },
                  // Text(value['errors'][0]['suggestion']),
                  error: (error, trace) => const Text('An error occured'),
                  loading: () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                'Running AI ...',
                                textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 80),
                              ),
                              TyperAnimatedText(
                                'Rubbing your mistakes',
                                textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 80),
                              ),
                              TyperAnimatedText(
                                'Evaluating...',
                                textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 80),
                              ),
                            ],
                          )
                        ],
                      )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TextImprovement(ctext)));
        },
        child: const Icon(
          Icons.keyboard_double_arrow_right_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  errorDialog(context, error) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text.rich(TextSpan(children: [
                TextSpan(
                    text: error['originalText'],
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red)),
                TextSpan(text: '-> ${error['suggestion']}')
              ])),
              content: Text(error['correctionType']),
            ));
  }
}
