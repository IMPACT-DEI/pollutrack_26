import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollutrack_26/screens/login.dart';
import 'package:pollutrack_26/screens/profile.dart';

//Exposure screen is stateful because it needs to update the UI (date and exposure value) when the user changes the date
class Exposure extends StatefulWidget {
  //final String name;
  //const Exposure({super.key, required this.name});
  const Exposure({super.key});

  @override
  State<Exposure> createState() => _ExposureState();
}

class _ExposureState extends State<Exposure> {
  // the state variables are used to store the exposure value and the current date
  double? _exposure;
  DateTime? _currentDate;

  @override
  void initState() {
    // initialize the exposure value and the current date
    _exposure = Random().nextDouble() * 100;
    _currentDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: 20),
            child: 
            // SingleChildScrollView is used to make the screen scrollable
              SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, User",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Daily Personal Exposure',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // InkWell widget is used to make the icons clickable
                            child: InkWell(
                              onTap: () {
                                // function that triggers the state when the icon is clicked
                                _changeDate('previous');
                              },
                              child: const Icon(
                                Icons.navigate_before,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('EEE, d MMM').format(_currentDate!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                // function that triggers the state when the icon is clicked
                                _changeDate('next');
                              },
                              child: const Icon(
                                Icons.navigate_next,
                              ),
                            ),
                          ),
                        ],
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
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (_exposure!.toInt()).toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              _exposure! / 100 < 0.33
                                  ? "Low"
                                  : _exposure! / 100 > 0.33 &&
                                          _exposure! / 100 < 0.66
                                      ? "Medium"
                                      : "High",
                              style: const TextStyle(fontSize: 12, color: Colors.black45),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              height: 15,
                              // ClipRect is used to clip the LinearProgressIndicator
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                // LinearProgressIndicator is used to show the progress of the exposure value
                                // value is set to the exposure value divided by 100 to get the percentage
                                child: LinearProgressIndicator(
                                  value: _exposure! / 100,
                                  backgroundColor: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Daily Trend",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "See how much you’ve been exposed throughout the day",
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                      const SizedBox(height: 30),
                      const Column(
                        children:[
                            Text('No data available',
                            style: TextStyle(fontSize:16),
                            textAlign: TextAlign.center,)
                        ],
                      ),
                      const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CircularProgressIndicator.adaptive()
                      ),      
                    ],
                  ),
                ),
        ),
      ),
    bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // logout button; pushReplacement because I don't want the user can go back to the exposure page when logged out
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              // async and await are used to wait for the result of the Profile screen
              // push because I want the user to be able to go back to the exposure page
              onPressed: () async{
                // name contains the result of the Profile screen
                final name =  await Navigator.of(context).push(MaterialPageRoute(builder:  (context) => Profile()));
                // if the result is not null, show it in a SnackBar
                if(name != null){
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
// function that changes the date and the exposure value when the user clicks on the icons
// setState is used to trigger the state of the widget
void _changeDate(String direction) {
  setState(() {
    if (direction == 'previous') {
      _currentDate = _currentDate!.subtract(const Duration(days: 1));
      _exposure = Random().nextDouble() * 100;
    } else if (direction == 'next') {
      _currentDate = _currentDate!.add(const Duration(days: 1));
      _exposure = Random().nextDouble() * 100;
    }
  });
}
}