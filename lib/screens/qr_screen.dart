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
  String? username;
  String? role;
  String? uid;
  String _data = "";

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
        if (mounted) {
          Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;
          setState(() {
            email = userData!['email'];
            username = userData['username'];
            role = userData['role'];
          });
        }
      });
    }
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(email ?? ""),
        backgroundColor: Colors.black,
      ),

      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(username ?? ""),
              Text('User role: $role'),
              SizedBox(
                height: 20,
              ),
              //QR generator
              Container(
                color: Colors.white,
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: uid ?? "", //text for qR generator
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text('Data: $uid'),
            ],
          )),
    );
  }
}