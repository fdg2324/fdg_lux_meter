import 'dart:async';
//import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// originally copied from 
// https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample10.dart

class LuxChart extends StatefulWidget {
  const LuxChart({required this.chartValue, super.key});

final double chartValue;
  final Color lineColor = Colors.blue;

  @override
  State<LuxChart> createState() => _LuxChartState();
}

class _LuxChartState extends State<LuxChart> {
  final limitCount = 100;
  final luxPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.5;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds:100), (timer) {
      while (luxPoints.length > limitCount) {
        luxPoints.removeAt(0);
      }
      setState(() {
        luxPoints.add(FlSpot(xValue, widget.chartValue));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return luxPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: LineChart(
                    duration: const Duration(milliseconds: 100),
                    LineChartData(
                      minY: 0,
                      maxY: 2000,
                      minX: luxPoints.first.x,
                      maxX: luxPoints.last.x,
                      lineTouchData: const LineTouchData(enabled: false),
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        sinLine(luxPoints),
                      ],
                      titlesData: const FlTitlesData(
                        show: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: true,
      ),
      // gradient: LinearGradient(
      //   colors: [widget.sinColor.withOpacity(0), widget.sinColor],
      //   stops: const [0.1, 1.0],
      // ),
      color: Colors.blue,
      barWidth: 4,
      isCurved: true,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}