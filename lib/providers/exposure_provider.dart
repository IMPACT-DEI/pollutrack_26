import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pollutrack_26/model/pm_25.dart';
import 'package:pollutrack_26/model/heart_rate.dart';
import 'package:pollutrack_26/services/csvData.dart';
import 'package:pollutrack_26/services/impact.dart';
import 'package:pollutrack_26/services/purpleair.dart';
import 'package:shared_preferences/shared_preferences.dart';

// this is the change notifier. it will manage all the logic of the exposure page: fetching the correct data from the online services
class ExposureProvider extends ChangeNotifier {
  // data to be used by the UI
  List<HR> heartRates = [];
  List<PM25> pm25 = [];
  double exposure = -1;
  bool isLoading = false;

  // selected day of data to be shown
  DateTime showDate = DateTime.now().subtract(const Duration(days: 1));

  // data generators with external services
  final Impact impact = Impact();
  final PurpleAir purpleAir = PurpleAir();
  final Csvdata csvData = Csvdata();

  // constructor of provider which manages the fetching of all data from the servers and then notifies the ui to build
  ExposureProvider() {
    getDataOfDay(showDate);
  }

  // method to get the data of the chosen day
  void getDataOfDay(DateTime showDate) async {
    showDate = DateUtils.dateOnly(showDate);
    print('Getting data of $showDate');
    this.showDate = showDate;
    _loading(); // method to give a loading ui feedback to the user
    heartRates = await impact.getHRData(showDate);

    final sp = await SharedPreferences.getInstance();
    final String apiKey = sp.getString('apiKey') ?? '';

    if (apiKey.isEmpty) {
      print('No API key found, using CSV data');
      List<DateTime> timeStamp = [];
      List<double> exposureListA = [];
      List<Map<String, dynamic>> csvData = await getCsvDataByDate(showDate);
      exposureListA = getPM(csvData, 'AirPredict-Padova-Mortise A');
      timeStamp = getTimeStamp(csvData, 'DateTime');

      pm25 = List.generate(
        timeStamp.length,
        (index) =>
            PM25(timestamp: timeStamp[index], value: exposureListA[index]),
      );
    } else {
      var pm25Map = await purpleAir.getHistoryData(showDate);
      pm25 = (pm25Map['data'])
          .map<PM25>(
            (e) => PM25(
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                (e[0] * 1000).toInt(),
              ),
              value: e[1],
            ),
          )
          .toList();
      pm25.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    print('Got data for $showDate: HR: ${heartRates.length}, PM2.5: ${pm25.length}');
    exposure = Random().nextDouble() * 100;
    notifyListeners();
  }

  void _loading() {
    heartRates = [];
    pm25 = [];
    exposure = -1;
    isLoading = true;
    notifyListeners();
  }
}
