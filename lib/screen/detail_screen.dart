import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screen/signin_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_app/services/local_notifications.dart';

import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final String imgURL;
  final String dateTime;

  DetailScreen({required this.imgURL, required this.dateTime});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Fire Alert - Details"),
          backgroundColor: Colors.red,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Detected on:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            dateTime,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Image.network(imgURL),
          // Image.asset(imgURL),
        ],
      ),
    );
  }
}
