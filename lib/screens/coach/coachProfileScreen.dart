import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../signin.dart';
import 'coachSalary.dart';

class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({Key? key}) : super(key: key);

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  @override
  Widget build(BuildContext context) {
    String? email;
    String? address;
    String? uid;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(email ?? ""),
          Text(
            'Coach Profile Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            child: Text("Salary"),
            onPressed: () {
              // FirebaseAuth.instance.signOut().then((value) {
              print("Salary total");
              // FirebaseAuth.instance.setPersistence(Persistence.NONE);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CoachSalary()));
              // });
            },
          ),
          ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                setState(() {
                  uid = null;
                  email = null;
                  address = null;
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
