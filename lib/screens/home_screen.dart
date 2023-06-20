import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:sample_app/screens/signin.dart';

import 'SecondRoute.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;
  String? address;
  String? uid;
  String _data = "";
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;

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

        // Text(email);
        // Text("address");
      });
    }
    final GlobalKey globalKey = GlobalKey();

    Future<void> convertQrToImg() async {
      // RenderRepaintBoundary boundary =
      //     globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // ui.Image image = await boundary.toImage();
      // final directory = (await getApplicationDocumentsDirectory()).path;
      // ByteData? byteData =
      //     await image.toByteData(format: ui.ImageByteFormat.png);
      // Uint8List pngBytes = byteData!.buffer.asUint8List();
      // File imgFile = File("$directory/qrCode.png");
      // await imgFile.writeAsBytes(pngBytes);
      // await Share.shareFiles([imgFile.path], text: "Your text share");
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                // setState(() {
                //   uid = null;
                //   email = null;
                //   address = null;
                // });
                FirebaseAuth.instance.setPersistence(Persistence.NONE);
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            },
          ),

          //QR generator
          RepaintBoundary(
            key: globalKey,
            child: QrImage(
              data: email ?? "", //text for qR generator
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text('Data: $email'),
          ElevatedButton(
            child: const Text('Share Qr'),
            // Within the `FirstRoute` widget
            onPressed: convertQrToImg,
          ),
          GestureDetector(
            onTap: () => convertQrToImg(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1)),
              child: Center(
                child: Text("Share"),
              ),
            ),
          )
        ],
      )),
    );
  }
}
