import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class MyState with ChangeNotifier {
  MyState({required this.slots}) {
    // _start();
  }
  final int slots;
  //
  bool _ready = false;
  bool get ready => _ready;
  bool _started = false;
  bool get started => _started;
  //
  final times = Queue<DateTime>();
  final seriesA = Queue<double>();
  final seriesB = Queue<double>();
  //
  late Timer _timer;
  void start() {
    _started = true;
    notifyListeners();
    final random = Random();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        times.add(DateTime.now());
        seriesA.add(random.nextDouble() * 100);
        seriesB.add(random.nextDouble() * 100);
        //
        if (times.length > slots) times.removeFirst();
        if (seriesA.length > slots) seriesA.removeFirst();
        if (seriesB.length > slots) seriesB.removeFirst();
        //
        if (timer.tick > 1) {
          _ready = true;
          notifyListeners();
        }
        debugPrint('Timer tick ${timer.tick}, time = ${times.last}');
      },
    );
  }

  //
  void stop() {
    _timer.cancel();
    _started = false;
    notifyListeners();
  }

  //
  List<List<double>> get dataRows => [
        seriesA.toList(),
        seriesB.toList(),
      ];
  //
  List<String> get xAxisData => times.map((t) => t.toHhmmss).toList();
  //
  List<String> get dataLegends => ['Series A', 'Series B'];
}

extension DateUtil on DateTime {
  String get toHhmmss {
    final pHour = hour.toString().padLeft(2, '0');
    final pMin = minute.toString().padLeft(2, '0');
    final pSec = second.toString().padLeft(2, '0');
    //
    return '$pHour:$pMin:$pSec';
  }
}
