import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_app/screen/history_fire.dart';
import 'package:my_app/screen/signin_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_app/services/local_notifications.dart';
import 'package:my_app/reusable_widgets/reusable_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({Key? key}) : super(key: key);

  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
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
  List<String> userDataUrl = [];
  List<String> userDataDate = [];
  late int newnum;
  late int oldnum;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final _localNotification = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    _activateListeners();
    Timer.periodic(Duration(milliseconds: 500), (timer) => getAllUserData());
    // Timer.periodic(Duration(milliseconds: 500), (timer) => getImageUrls());
    super.initState();
  }

  Future<void> _activateListeners() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var newnum =prefs.getInt("newnum");
    // print(newnum);
  }


  List<User> users = [];
  Future<void> getAllUserData() async {

    final reference = FirebaseDatabase.instance.reference().child('user');
    // DataSnapshot dataSnapshot = await reference.once();
    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    List<Map<String, String>> userDataList = [];
    List<String> userurl =[];
    List<String> userdate = [];
    // Map<dynamic, dynamic> userData = dataSnapshot.value;
    dynamic userData = dataSnapshot.value;
    // print(userData);
    // Alert(context: context, title: "Notifition", desc: "FIRE FIRE FIRE!!!")
    // .show();
    userData.forEach((key, value) {
      String date = value['date'] as String;
      String url = value['imageUrl'];
      // Map<String, String> userData = {'date': date, 'imageUrl': url};
      // userDataList.add(userData);
      String urldate = url + date ;
      userurl.add(urldate);
    });

    SharedPreferences prefs =await SharedPreferences.getInstance();
    var newnum =prefs.getInt("newnum");
    if (newnum != userurl.length) {
      Alert(context: context, title: "Notifition", desc: "FIRE FIRE FIRE!!!")
      .show();
    }
    prefs.setInt('newnum', userurl.length);


    setState(() {
      userDataDate = userdate;
      userDataUrl = userurl ;
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
                    FirebaseAuth.instance.signOut().then((value) async {
                      SharedPreferences prefs =await SharedPreferences.getInstance();
                      prefs.remove('email2');
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
                  'Today\'s Notifications',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),

              if (userDataUrl.isNotEmpty)
                ...userDataUrl
                    .map((urldate) => notification_frame(context, urldate,() {}))
                    .toList()
              else
                Center(
                  child: Text('Your place are safe!'),
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
