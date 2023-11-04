import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String notifi = "Waiting for notification";
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          notifi =
          "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
        });
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        notifi =
        "${event.notification!.title} ${event.notification!.body} I am coming from foreground";
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notifi =
        "${event.notification!.title} ${event.notification!.body} I am coming from background";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(notifi),
      ),
    );
  }
}