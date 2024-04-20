import 'package:flutter/material.dart';
import 'package:lingolearn/views/last.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Speak extends StatefulWidget {
  const Speak({super.key, required this.text});
  final String text;

  @override
  _SpeakState createState() => _SpeakState();
}

class _SpeakState extends State<Speak> {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  bool isListening = false;
  String transcript = '';
  List<TextSpan> textSpans = [];
  int highlightIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
  }

  Future<void> initializeSpeechToText() async {
    speechToText.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (error) => print('Speech recognition error: $error'),
    );
  }

  void startListening() async {
    bool available = await speechToText.initialize();

    if (available && !isListening) {
      setState(() {
        isListening = true;
        transcript = '';
        textSpans.clear();
        highlightIndex = 0;
      });

      speechToText.listen(
        onResult: handleSpeechResult,
        listenFor: const Duration(seconds: 30),
      );
    } else {
      stopListening();
    }
  }

  void stopListening() {
    setState(() => isListening = false);
    speechToText.stop();

    bool allCorrect = true;
    for (var span in textSpans) {
      if (span.style?.color == Colors.red) {
        allCorrect = false;
        break;
      }
    }

    final snackBar = SnackBar(
      content: Text(allCorrect
          ? 'Well done!'
          : 'Try again! Make sure to speak the text exactly.'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      transcript = result.recognizedWords;
      if (result.finalResult) {
        isListening = false;
        validateSpeech(transcript);
      }
    });
  }

  void validateSpeech(String newTranscript) {
    final targetWords = widget.text.toLowerCase().split(' ');
    final spokenWords = newTranscript.toLowerCase().trim().split(' ');

    setState(() {
      textSpans = [];
      highlightIndex = 0;

      for (int i = 0; i < spokenWords.length && i < targetWords.length; i++) {
        if (spokenWords[i] == targetWords[i]) {
          textSpans.add(TextSpan(
            text: '${targetWords[i]} ',
            style: const TextStyle(color: Colors.green),
          ));
          highlightIndex++;
        } else {
          textSpans.add(TextSpan(
            text: '${spokenWords[i]} ',
            style: const TextStyle(color: Colors.red),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech-to-Text Essay Validation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Please speak the following text aloud:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.text,
                  style: const TextStyle(fontSize: 18, color: Colors.blue)),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                children: textSpans,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startListening,
              child: Text(isListening ? 'Stop Listening' : 'Start Listening'),
            ),
            if (!isListening &&
                !textSpans.every((span) => span.style?.color == Colors.green))
              ElevatedButton(
                onPressed: startListening,
                child: const Text('Retry'),
              ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LastPage(text: transcript)));
                },
                child: const Text("Next")),
          ],
        ),
      ),
    );
  }
}
