import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';

class LastPage extends ConsumerWidget {
  const LastPage({super.key, this.text});
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(text);
    Map<String, double> dataMap = {"Correct Answers": 85, "Mistakes": 15};

    List<Color> colorList = [
      Colors.blue,
      Colors.red,
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_protected_setup,
            size: 100,
          ),
          Center(
            child: Text(
              'Rewrite & Speak',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: const Icon(Icons.home_filled),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedTextKit(
              repeatForever: false,
              totalRepeatCount: 1,
              animatedTexts: [
                TyperAnimatedText(
                  text ?? "", // Use empty string if text is null
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 10),
                ),
              ],
            ),
          ),
          PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "HYBRID",
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
            // gradientList: ---To add gradient colors---
            // emptyColorGradient: ---Empty Color gradient---
          )
        ],
      ),
    );
  }
}
