// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'chart.dart';

void main() {
  return runApp(const GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  const GaugeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

/// Represents MyHomePage class
class MyHomePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  double luxValue = 100;
  double maxLuxValue = 3000;

  void onData(int value) async {
    print("Lux value: $luxValue");
    setState(() {
      if (value < maxLuxValue) {
        luxValue = value.toDouble();
      }
    });
  }

  void startListening() {
    var light = Light();
    try {
      light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('FDG Lux Meter'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,),
        body: Column(
          children: [
            _getRadialGauge(),
            Slider(
              value: luxValue,
              min: 0,
              max: maxLuxValue,
              onChanged: (value) {
                print(value);
                setState(() {
                  luxValue = value;
                });
              },
            ),
            const LuxChart()
          ],
        ));
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
        // title: const GaugeTitle(
        //     text: 'Lux Meter',
        //     textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 1000, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 300,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 300,
                endValue: 600,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 600,
                endValue: 1000,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: luxValue)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Text(luxValue.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }
}