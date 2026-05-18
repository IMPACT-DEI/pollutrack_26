import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Csvdata {
  Future<bool> getCsvData() async {
    String csvString = await rootBundle.loadString(
      'assets/us-epa-pm25-aqi.csv',
    );
    List<List<dynamic>> csvData = Csv(
      fieldDelimiter: ';',
      lineDelimiter: '\n',
    ).decode(csvString);

    List<String> headers = List<String>.from(csvData[0]);

    List<Map<String, dynamic>> csvDataMap = [];
    for (var i = 1; i < csvData.length; i++) {
      Map<String, dynamic> row = {};

      for (var j = 0; j < headers.length; j++) {
        String columnName = headers[j];
        String value = csvData[i][j].toString().trim();

        switch (columnName) {
          case 'DateTime':
            row[columnName] = DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
            break;
          case 'AirPredict-Padova-Mortise A':
            row[columnName] = double.tryParse(value);
            break;
          case 'AirPredict-Padova-Mortise B':
            row[columnName] = double.tryParse(value);
            break;
        }
      }
      csvDataMap.add(row);
    } // for

    await saveCsvData(csvDataMap);
    return true;
  }
}

Future<void> saveCsvData(List<Map<String, dynamic>> csvDataMap) async {
  final sp = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> convertedData = csvDataMap.map((row) {
    return row.map(
      (key, value) =>
          MapEntry(key, value is DateTime ? value.toIso8601String() : value),
    );
  }).toList();
  String jsonString = jsonEncode(convertedData);
  await sp.setString('csv_data', jsonString);
}

Future<List<Map<String, dynamic>>> loadCsvData() async {
  final sp = await SharedPreferences.getInstance();
  String? jsonString = sp.getString('csv_data');

  if (jsonString != null) {
    List<dynamic> decodedList = jsonDecode(jsonString);

    List<Map<String, dynamic>> csvDataMap = decodedList
        .map<Map<String, dynamic>>((row) {
          Map<String, dynamic> mappedRow = Map<String, dynamic>.from(
            row,
          ); // Converti il tipo

          return mappedRow.map(
            (key, value) => MapEntry(
              key,
              key == 'DateTime' ? DateTime.parse(value) : value,
            ),
          );
        })
        .toList();

    return csvDataMap;
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> getCsvDataByDate(DateTime date) async {
  var today = DateTime.now();
  var daysFromToday = today.difference(date).inDays;

  List<Map<String, dynamic>> csvDataMap = await loadCsvData();
  List<DateTime> uniqueDays = csvDataMap
      .map((e) {
        DateTime datetime = e['DateTime'];
        datetime = datetime.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        return datetime;
      })
      .toList()
      .toSet()
      .toList();
  DateTime mappedDay = uniqueDays.reversed
      .toList()[daysFromToday % uniqueDays.length];
  List<Map<String, dynamic>> filteredData = csvDataMap.where((row) {
    DateTime rowDate = row['DateTime'];
    return rowDate.year == mappedDay.year &&
        rowDate.month == mappedDay.month &&
        rowDate.day == mappedDay.day;
  }).toList();

  return filteredData;
}

List<DateTime> getTimeStamp(
  List<Map<String, dynamic>> csvData,
  String columnName,
) {
  List<DateTime> values = [];
  for (var row in csvData) {
    var value = row[columnName];
    if (value != null && value is DateTime) {
      values.add(value);
    }
  }
  return values;
}

List<double> getPM(List<Map<String, dynamic>> csvData, String columnName) {
  List<double> values = [];
  for (var row in csvData) {
    var value = row[columnName];
    if (value != null && value is num) {
      values.add(value.toDouble());
    }
  }
  return values;
}
