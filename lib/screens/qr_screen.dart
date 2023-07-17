import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:sample_app/screens/signin.dart';

import '../services/authServices.dart';

import 'member/UserNav.dart';
import 'member/qr_scan.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? email;
  String? address;
  String? uid;
  String _data = "";

  // Future<void> getUserData() async {
  //   final authService = AuthService();
  //   uid = await authService.getCurrentUserUid();
  //
  //   if (uid != null) {
  //     final userData = await authService.getUserData(uid!);
  //     if (userData != null) {
  //       setState(() {
  //         email = userData['email'];
  //         address = userData['address'];
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final GlobalKey globalKey = GlobalKey();
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
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(email ?? ""),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(email ?? ""),
          Text(address ?? ""),
          Text(uid ?? ""),
          ElevatedButton(
            child: const Text('Open Qr'),
            // Within the `FirstRoute` widget
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ProgressChart()),
              // );
            },
          ),

          ElevatedButton(
            child: const Text('Open scanner'),
            // Within the `FirstRoute` widget
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScan()),
              );
            },
          ),

          //QR generator
          RepaintBoundary(
            key: globalKey,
            child: QrImage(
              data: uid ?? "", //text for qR generator
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text('Data: $uid'),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(MaterialPageRoute(builder: (context) => Home()));
            },
            child: Icon(Icons.navigate_before),
          ),
        ],
      )),
    );
  }
}
