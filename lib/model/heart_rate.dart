import 'dart:math';

import 'package:intl/intl.dart';

class HR {
  // this class models the single heart rate data point
  final DateTime timestamp;
  final int value;

  HR({required this.timestamp, required this.value});

  HR.fromJson(String date, Map<String, dynamic> json)
    : timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).parse('$date ${json["time"]}'),
      value = json["value"];

  @override
  String toString() {
    return 'HR{timestamp: $timestamp, value: $value}';
  }
}

class FitbitGen {
  final Random _random = Random();

  List<HR> fetchHR() {
    return List.generate(
      100,
      (index) => HR(
        timestamp: DateTime.now().subtract(Duration(hours: index)),
        value: _random.nextInt(180),
      ),
    );
  }
}
