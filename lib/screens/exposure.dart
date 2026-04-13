import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pollutrack_26/providers/exposure_provider.dart';
import 'package:pollutrack_26/screens/profile.dart';
import 'package:provider/provider.dart';

//Exposure screen is stateless because all the logic is handled by the provider. it just listens to the changes of the provider and rebuilds when necessary
class Exposure extends StatelessWidget {
  const Exposure({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 10,
            bottom: 20,
          ),
          child:
              // SingleChildScrollView is used to make the screen scrollable
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, User",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(),
                              ),
                            );
                          },
                          icon: Icon(
                            MdiIcons.accountCircle,
                            size: 40,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Daily Personal Exposure',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Consumer<ExposureProvider>(
                      builder: (context, value, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // InkWell widget is used to make the icons clickable
                            child: InkWell(
                              onTap: () {
                                // function that triggers the provider to get the data of the previous day when the icon is clicked
                                value.getDataOfDay(
                                  value.showDate.subtract(Duration(days: 1)),
                                );
                              },
                              child: const Icon(Icons.navigate_before),
                            ),
                          ),
                          Text(DateFormat('EEE, d MMM').format(value.showDate)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                // function that triggers the provider to get the data of the next day when the icon is clicked
                                value.getDataOfDay(
                                  value.showDate.add(Duration(days: 1)),
                                );
                              },
                              child: const Icon(Icons.navigate_next),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Cumulative Exposure",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Total count of all the pollution you've breathed in the day",
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 10,
                        bottom: 4,
                      ),
                      child: Consumer<ExposureProvider>(
                        builder: (context, value, child) => value.isLoading
                            ? SizedBox(
                                height: 80,
                                child:
                                    Center(child: const CircularProgressIndicator.adaptive()),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (value.exposure.toInt()).toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    value.exposure / 100 < 0.33
                                        ? "Low"
                                        : value.exposure / 100 > 0.33 &&
                                              value.exposure / 100 < 0.66
                                        ? "Medium"
                                        : "High",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    height: 15,
                                    // ClipRect is used to clip the LinearProgressIndicator
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      // LinearProgressIndicator is used to show the progress of the exposure value
                                      // value is set to the exposure value divided by 100 to get the percentage
                                      child: LinearProgressIndicator(
                                        value: value.exposure / 100,
                                        backgroundColor: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                    Consumer<ExposureProvider>(
                      builder: (context, value, child) => AspectRatio(
                        aspectRatio: 16 / 9,
                        child: value.isLoading
                            ? CircularProgressIndicator.adaptive()
                            : Container(
                                color: Colors.grey.withValues(alpha: 0.2),
                                child: Center(
                                  child: Text(
                                    "Graph coming soon!",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
