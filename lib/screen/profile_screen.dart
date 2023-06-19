import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _database = FirebaseDatabase.instance.reference();
  List<String> imageUrls = [];
  @override
  void initState() {
    _activateListeners();
    Timer.periodic(Duration(milliseconds: 500), (timer) => getImageUrls());
    super.initState();
  }

  void _activateListeners() {
    _database.child('user').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Alert(context: context, title: "Notifition", desc: "FIRE FIRE FIRE!!!")
            .show();
      }
    });
  }

  Future<void> getImageUrls() async {
    // Create a reference to the folder you want to list
    // In this example, we're listing all files in the "images" folder
    final ref = FirebaseStorage.instance.ref().child('Fire_Detection');

    // Get a list of all files in the specified location
    final result = await ref.listAll();
    List<String> imageList = [];
    // Iterate through each file and get its download URL
    for (final file in result.items) {
      final downloadURL = await file.getDownloadURL();
      imageList.add(downloadURL);
    }
    setState(() {
      imageUrls = imageList;
    });
  }

  List<String> imgList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: imageUrls.isNotEmpty
          ? GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imageUrls[index],
                      width: 200,
                      height: 200,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
