import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pollutrack_26/providers/exposure_provider.dart';
import 'package:pollutrack_26/screens/exposure.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const route = '/home/';
  static const routeDisplayName = 'HomePage';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.dotsHexagon),
      label: 'Personal Exposure',
    ),
    BottomNavigationBarItem(icon: Icon(MdiIcons.thoughtBubble), label: 'Tips'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4DFD4),
      body: _selectedIndex == 0
          ? ChangeNotifierProvider<ExposureProvider>(
              create: (context) => ExposureProvider(),
              builder: (context, child) => Exposure(),
            )
          : Center(
            child: Text(
              'Tips coming soon!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        onTap: (index) {
          // Handle changing the screen based on the tapped index
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
