import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List pages = [
    {
      'title': 'LingoLearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
    {
      'title': "Sessions",
      'desc': "Do everyday to improve english and better express yourself",
      'image': "assets/imgs/session.png"
    },
    {
      'title': 'lingolearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
    {
      'title': 'lingolearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
    {
      'title': 'lingolearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
    {
      'title': 'lingolearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
    {
      'title': 'lingolearn',
      'desc': '30 mins for 30 days',
      'image': "assets/imgs/english.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      overrideDone: Container(),
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      // autoScrollDuration: 3000,
      curve: Curves.fastLinearToSlowEaseIn,
      // controlsMargin: const EdgeInsets.fromLTRB(0,0,0,0 ),
      // controlsPadding: const EdgeInsets.all(16.0),
      dotsDecorator: const DotsDecorator(
        spacing: EdgeInsets.all(5),
        size: Size(7.0, 7.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      pages: [
        PageViewModel(
          useScrollView: true,
          titleWidget: const Text(
            "LingoLearn",
            textScaler: TextScaler.linear(2.3),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "30 mins for 30 days",
          image: Image.asset("assets/imgs/english.jpg", height: 350.0),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Take Sessions",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "Do everyday to improve english and better express yourself",
          image: Center(
            child: Image.asset("assets/imgs/session.png", height: 300.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Write Essays",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "Take photo to upload into lingolearn",
          image: Center(
            child: Image.asset("assets/imgs/essay.png", height: 300.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Grammar Correction",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "See what grammatical mistakes you did and understand",
          image: Center(
            child: Image.asset("assets/imgs/grammar.png", height: 200.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Fluency and Clarity",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "Rewrite your essay after looking at improvements",
          image: Center(
            child: Image.asset("assets/imgs/fluency.png", height: 200.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Finish off with speaking",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          body: "Read aloud to fit the grammar and improvements in your brain",
          image: Center(
            child: Image.asset("assets/imgs/speak.png", height: 200.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            "Rinse and Repeat",
            textScaler: TextScaler.linear(2),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          bodyWidget: Column(
            children: [
              const Text(
                "Consistently and you will change yourself",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    60,
                    20,
                    20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(10)),
                      child: const Text("Let's Go"),
                      onPressed: () {
                        context.go('/profile');
                      },
                    ),
                  ))
            ],
          ),
          image: Center(
            child: Image.asset("assets/imgs/technique.png", height: 200.0),
          ),
          decoration: const PageDecoration(
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        )
      ],
      showBackButton: false,
      showNextButton: false,
      back: const Icon(Icons.arrow_back),
      // done: const Text("Login"),
      // onDone: (){
      // context.go('/home');
      // },
    );
  }
}
