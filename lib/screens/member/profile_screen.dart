import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? uid;
  String? username;
  String? email;
  String? phone_no;
  String? address;
  String? imageUrl;
  int? level;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _calculateUserLevel();// Load user data when the widget is created
  }

  // Method to load user data from Firebase Firestore
  Future<void> _loadUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      final userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        if (data != null) {
          setState(() {
            email = data['email'];
            username = data['username'];
            phone_no = data['phone_no'];
            address = data['address'];
            imageUrl = data['imageUrl'];
            if (data.containsKey('level')) {
              level = data['level'];
            } else {
              level = null;
            }
          });
        }
      }
    }
  }

  // Future<void> _calculateUserLevel() async {
  //
  //   final CollectionReference<Map<String, dynamic>> attendanceCollectionRef =
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('attendance');
  //
  //   final QuerySnapshot<Map<String, dynamic>> attendanceQuerySnapshot =
  //   await attendanceCollectionRef.get();
  //
  //   final int attendanceCount = attendanceQuerySnapshot.size;
  //
  //   int calculatedUserLevel =0;
  //
  //   calculatedUserLevel = attendanceCount ~/ 5;
  //
  //   print('calculatedUserLevel: $calculatedUserLevel');
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .update({'level': calculatedUserLevel});
  //
  //   setState(() {
  //     userLevel = calculatedUserLevel;
  //   });
  //
  //   setState(() {
  //     userLevel = calculatedUserLevel;
  //   });
  //
  //   print('Attendance Count: $attendanceCount');
  // }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile image
          CircleAvatar(
            radius: 80,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null ? Icon(Icons.person, size: 60) : null,
          ),
          const SizedBox(height: 20),
          Text(
            '$username',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Email: ${email ?? "N/A"}',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20),
          Text(
            'Phone number: ${phone_no ?? "N/A"}',
            style: TextStyle(fontSize: 15),
          ),


        const SizedBox(height: 20),
          Text(
            'Address: ${address ?? "N/A"}',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 50),
        // Display user level if it's set
            Text(
              'Level: $level',
              style: TextStyle(fontSize: 15),
            ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff9b1616),
            ),
            child: Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                setState(() {
                  uid = null;
                  email = null;
                  username = null;
                  address = null;
                  imageUrl = null;
                });
                // FirebaseAuth.instance.setPersistence(Persistence.NONE);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signin()));
              });
            },
          ),
        ],
      ),
    );
  }
}
