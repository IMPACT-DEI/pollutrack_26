import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollutrack_26/screens/login.dart';
import 'package:pollutrack_26/screens/profile.dart';

class ExposureStateless extends StatelessWidget {
  final DateTime currentDate;
  final double exposure;
  //final String name;


  const ExposureStateless({
    super.key,
    required this.currentDate,
    required this.exposure,
    //required this.name
  });

  // function that simulates the change of state navigating to the same screen with different data
  void _changeDate(BuildContext context, String direction) {
    DateTime newDate;

    if (direction == 'previous') {
      newDate = currentDate.subtract(const Duration(days: 1));
    } else {
      newDate = currentDate.add(const Duration(days: 1));
    }

    final newExposure = Random().nextDouble() * 100;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExposureStateless(
          currentDate: newDate,
          exposure: newExposure,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exposureLevel = exposure / 100 < 0.33
        ? "Low"
        : exposure / 100 < 0.66
            ? "Medium"
            : "High";

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hello, User", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                const Text(
                  'Daily Personal Exposure',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                ),

                // DATE SELECTOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _changeDate(context, 'previous'),
                      child: const Icon(Icons.navigate_before),
                    ),
                    Text(DateFormat('EEE, d MMM').format(currentDate)),
                    InkWell(
                      onTap: () => _changeDate(context, 'next'),
                      child: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),

                const Text("Cumulative Exposure", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                const Text(
                  "Total count of all the pollution you've breathed in the day",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exposure.toInt().toString(),
                          style: const TextStyle(fontSize: 16)),
                      Text(exposureLevel,
                          style: const TextStyle(fontSize: 12, color: Colors.black45)),

                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        height: 15,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: exposure / 100,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Daily Trend", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                const Text(
                  "See how much you’ve been exposed throughout the day",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),

                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ],
            ),
          ),
        ),
      ),

      // BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // LOGOUT
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                );
              },
            ),

            // PROFILE
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () async {
                final name = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );

                if (name != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Name updated! New name: $name'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}