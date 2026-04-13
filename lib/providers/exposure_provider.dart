import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pollutrack_26/model/pm_25.dart';
import 'package:pollutrack_26/model/heart_rate.dart';

// this is the change notifier. it will manage all the logic of the exposure page: fetching the correct data from the online services
class ExposureProvider extends ChangeNotifier {
  // data to be used by the UI
  List<HR> heartRates = [];
  List<PM25> pm25 = [];
  double exposure = -1;
  bool isLoading = false;

  // selected day of data to be shown
  DateTime showDate = DateTime.now();

  // data generators faking external services
  final FitbitGen fitbitGen = FitbitGen();
  final PurpleAirGen purpleAirGen = PurpleAirGen();

  // constructor of provider which manages the fetching of all data from the servers and then notifies the ui to build
  ExposureProvider() {
    getDataOfDay(showDate);
  }

  // method to get the data of the chosen day
  void getDataOfDay(DateTime showDate) async {
    this.showDate = showDate;
    _loading(); // method to give a loading ui feedback to the user
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // faking time required to get data from internet
    heartRates = fitbitGen.fetchHR();
    pm25 = purpleAirGen.fetchPM();
    exposure = Random().nextDouble() * 100;
    print(
        'Generated for $showDate: ${heartRates.map((e) => e.value.toString()).reduce((value, element) => '$value, $element')}');
    
    // after selecting all data we notify all consumers to rebuild
    isLoading = false;
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
