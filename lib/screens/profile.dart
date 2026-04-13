import 'package:flutter/material.dart';
import 'package:pollutrack_26/screens/login.dart';

// the profile screen is a stateful widget because it has some text fields that the user can edit and we want to show a save button only when there are changes to be saved.
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  bool hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          hasChanges
              ? IconButton(
                  onPressed: () => print(
                    'Saved ${_nameController.text} ${_surnameController.text}',
                    //TODO: implement saving the changes to the user profile
                  ),
                  icon: Icon(Icons.save),
                )
              : SizedBox.shrink(),
        ],
      ), //appBar adds the go back arrow
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(height: 5),
            Text(
              "Info about you and your preferences",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
            SizedBox(height: 20),
            Text("Account", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  hasChanges = true;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
              onChanged: (value) {
                setState(() {
                  hasChanges = true;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: TextStyle(fontSize: 16)),
                  Text(
                    "Pollutrack aims to improve the consciousness of the user to the air pollutants issue. The user can track the amount of pollutants they has been exposed to during the day and learn useful information about them.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("version 2.0.0"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: const Text('Logout'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
