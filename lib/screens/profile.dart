import 'package:flutter/material.dart';
import 'package:pollutrack_26/screens/exposure.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(), appBar adds the go back arrow
      body: SafeArea(
        child: Padding(
          padding:
               EdgeInsets.only(left: 12.0, right: 12.0, top: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Info about you and your preferences",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                "Account",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name'
                ),
                ),
                const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname'
                ),
                ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Pollutrack aims to improve the consciousness of the user to the air pollutants issue. The user can track the amount of pollutants they has been exposed to during the day and learn useful information about them.",
                      style: TextStyle(
                          
                          fontSize: 14, color: Colors.black.withOpacity(0.4)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text("version 2.0.0"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Pop the current screen and return the name and surname to the Exposure Page
                    // Navigator.pop(context, 'Nome Cognome');
                    Navigator.pop(context, '${_nameController.text} ${_surnameController.text}');
                    //Navigator.push(context, MaterialPageRoute(builder:  (context) => Exposure(name: '${_nameController.text} ${_surnameController.text}',),),);
                  },
                ),
          ),
            ])
        ),
      ),
    );
  }
}