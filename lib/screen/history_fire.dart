import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screen/history_fire.dart';
import 'package:my_app/screen/home_screen1.dart';
import 'package:my_app/screen/signin_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_app/services/local_notifications.dart';
import 'package:my_app/reusable_widgets/reusable_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // String notificationMsg = "Waiting for notifications";
  // @override
  // void initState() {
  //   super.initState();
  //   LocalNotificationService.initialize();
  //   FirebaseMessaging.instance.getInitialMessage().then((event) {
  //     if (event != null) {
  //       setState(() {
  //         notificationMsg =
  //             "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
  //       });
  //     }
  //   });

  //   FirebaseMessaging.onMessage.listen((event) {
  //     LocalNotificationService.showNotificationOnForeground(event);
  //     setState(() {
  //       notificationMsg =
  //           "${event.notification!.title} ${event.notification!.body} I am coming from foreground";
  //     });
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     setState(() {
  //       notificationMsg =
  //           "${event.notification!.title} ${event.notification!.body} I am coming from background";
  //     });
  //   });
  // }
  final _database = FirebaseDatabase.instance.reference();
  DateTime? _lastPressedAt;
  List<String> imageUrls = [];
  @override
  void initState() {
    // _activateListeners();
    Timer.periodic(Duration(milliseconds: 500), (timer) => getImageUrls());
    super.initState();
  }

  void _activateListeners() {
    _database.child('user').onValue.listen((event) {
      // if (event.snapshot.value != n) {
      Alert(context: context, title: "Notifition", desc: "FIRE FIRE FIRE!!!")
          .show();
      // }
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

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Press back again to exit'),
          ));
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Fire Alert"),
            backgroundColor: Colors.red,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 0),
                child: ElevatedButton(
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  // ),
                  style: ElevatedButton.styleFrom(
                    elevation:
                        0, // thiết lập giá trị elevation là 0 để tắt boxShadow
                    backgroundColor: Colors.red, 
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 5.0),
                      Text("Log out"),
                    ],
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      print("Signed Out");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.today),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen1()));
                },
              ),
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryScreen()));
                },
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: Text(
                  'History fire',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              if (imageUrls.isNotEmpty)
                ...imageUrls
                    .map((url) => notification_frame(context, url,() {}))
                    .toList()
              else
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        // body: Center(
        //   child: Text(
        //     notificationMsg,
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ),
    );
  }
}
