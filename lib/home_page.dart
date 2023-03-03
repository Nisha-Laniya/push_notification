import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification/local_notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String notificationMsg = 'Waiting for notification';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalNotificationService.initialize();

    //TERMINATED STATE
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if(event != null) {
        setState(() {
          notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
        });
      }
    });

    //FOREGROUND STATE
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(event);
      setState(() {
          notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from foreground";
      });
    });

    //BACKGROUND STATE
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from background";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Firebase Notification'),
      ),
      body: Center(
        child: Text(notificationMsg),
      ),
    );
  }
}
