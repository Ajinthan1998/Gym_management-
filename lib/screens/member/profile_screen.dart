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
  String? medical_issues;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is created
  }

  // Method to load user data from Firebase Firestore
  Future<void> _loadUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;

      // Fetch user data from Firestore based on UID
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
            address = data['address'];
            medical_issues = data['medical_issues'];
            imageUrl = data['imageUrl'];
          });
        }
      }
    }
  }

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
          const SizedBox(height: 20),
          Text(
            'Medical issues: ${medical_issues ?? "N/A"}',
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
