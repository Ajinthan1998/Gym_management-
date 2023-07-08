

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String currentDate = DateTime.now().toString().split(' ')[0];

class _HomeScreenState extends State<HomeScreen> {
  Stream<int>? attendanceCountStream;
  DatabaseReference attendanceCountRef =
  FirebaseDatabase.instance.reference().child('attendanceCount').child('currentCount');


  void initState() {
    super.initState();
    attendanceCountStream = attendanceCountRef.onValue.map((event) {
      return event.snapshot.value as int? ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body:  Column(
        children: [
      Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Home Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Image(
            image: AssetImage("assets/images/jk fitness.jpg"),
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        ],
      ),
      ),
          StreamBuilder<int>(
            stream: attendanceCountStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int attendanceCount = snapshot.data!;
                return Center(
                  child: Text('Attendance Count: $attendanceCount'),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );


  }

}
