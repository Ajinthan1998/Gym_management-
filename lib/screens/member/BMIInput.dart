import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/reusable_widgets.dart';
import 'prog.dart';

class BMI extends StatefulWidget {
  const BMI({Key? key}) : super(key: key);

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  TextEditingController _bmiTextController = TextEditingController();
  String? email;
  String? address;
  String? uid;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    // email = user?.email;

    if (uid != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      userDocRef.get().then((DocumentSnapshot documentSnapshot) {
        // Map<String, dynamic> userData = documentSnapshot.data!.data()
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          email = userData!['email'];
          address = userData['address'];
        });
      });
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("BMI insertData"),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Insert BMI",
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _bmiTextController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'MBI',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  CollectionReference usersCollection =
                      FirebaseFirestore.instance.collection('users');
                  DocumentReference userDoc = usersCollection.doc(uid);
                  DocumentReference bmiDoc = userDoc.collection('bmi').doc();
                  bmiDoc.set({
                    'value': _bmiTextController.text,
                    'time': DateTime.now(),
                  }).then((_) {
                    print("Created New account");
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                  // _bmiTextController.clear();
                },
                child: Text("Insert"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return Colors.black;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChartScreen()));
                  },
                  child: Text("To chart"))
            ],
          ),
        ),
      ),
    );
  }
}
