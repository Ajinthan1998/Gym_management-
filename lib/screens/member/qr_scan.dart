import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class QRScan extends StatefulWidget{
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan>{
  String role="";
  String currentDate = DateTime.now().toString().split(' ')[0];
  String currentTime = DateTime.now().toLocal().toString().split(' ')[1].substring(0, 5);
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result ="";


  Future<int> getCurrentAttendanceCount(String role) async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .get();

    int totalCount = 0;

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('attendance')
          .where('date', isEqualTo: currentDate)
          .where('availability',isEqualTo: "Yes")
          .get();
      totalCount += attendanceSnapshot.docs.length;

    }
    return totalCount;
  }

  Future<List<String>> getCurrentAvailableCoach() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "coach")
        .get();

    List<String> usernames = [];

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('attendance')
          .where('date', isEqualTo: currentDate)
          .where('availability', isEqualTo: "Yes")
          .get();

      if (attendanceSnapshot.docs.isNotEmpty) {
        String username = userDoc.get('username');
        usernames.add(username);
      }
    }

    return usernames;
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState((){
        result =scanData.code!;
      });
    });
  }

  // void processString(String attendanceType) {
  //   String fieldToUpdate;
  //   if (result.isNotEmpty) {
  //     // Collection reference for users
  //     CollectionReference usersCollection = FirebaseFirestore.instance
  //         .collection('users');
  //
  //     // Document reference for the user
  //     DocumentReference userDoc = usersCollection.doc(result);
  //     userDoc.get().then((userSnapshot) {
  //       // Retrieve the current value of inTime
  //       String currentDate = DateTime.now().toString().split(' ')[0];
  //
  //       DocumentReference attendanceDoc = userDoc.collection('attendance').doc(
  //           currentDate);
  //
  //       if (attendanceType == 'intime') {
  //         fieldToUpdate = "intime";
  //         return fieldToUpdate;
  //       } else if (attendanceType == 'outtime') {
  //         fieldToUpdate = "outtime";
  //         return fieldToUpdate;
  //       }
  //
  //       });
  //
  //     }
  //
  // }

  Future<void> handleButtonPress(String attendanceType) async {
    if (result.isNotEmpty) {

      //Collection reference for users
      print('Currentdate: $currentDate');
      // int currentAttendanceCount = await getCurrentAttendanceCount();
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentReference userDoc = usersCollection.doc(result);
      userDoc.get().then((userSnapshot) async {
       role =userSnapshot.get('role');
       print('Role name :$role');
        // Retrieve the current value of inTime
        DocumentReference attendanceDoc = userDoc.collection('attendance').doc(currentDate);
        String fieldToUpdate = attendanceType == 'In' ? 'intime' : 'outtime';

        // attendanceDoc.update({
        //   fieldToUpdate: DateTime.now()
        // });

        if (attendanceType == 'In') {
          await attendanceDoc.set({
            'intime': currentTime,
            'availability': "Yes",
            'date'  : currentDate,
          }, SetOptions(merge: true)).then((_){
            print('Attendance document created/updated successfully');
          }).catchError((error) {
            print('Failed to create/update attendance document: $error');
          });
        } else {
          await attendanceDoc.set({
            'outtime': currentTime,
            'availability':"No"
          }, SetOptions(merge: true)).then((_){
            print('Failed to create/update attendance document');
          });
        }

        // int updatedAttendanceCount =await getCurrentAttendanceCount() ;
        // print('Current Attendance Count: $updatedAttendanceCount');
        //
        // CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendanceRegister');
        // attendanceCollection
        //     .doc(currentDate)
        //     .set({
        //   'attendanceCount': updatedAttendanceCount
        // }, SetOptions(merge: true)).then((_) {
        //   print("Created New account");
        // }).onError((error, stackTrace) {
        //   print("Error ${error.toString()}");
        // });
        final DatabaseReference attendanceCountRef =
        FirebaseDatabase.instance.reference().child('attendanceCount');



       int updatedAttendanceCount=0;

        String roles="";

        if(role=='user') {
          updatedAttendanceCount = await getCurrentAttendanceCount('user');
          roles="userCount";
        }
        else if(role=='coach') {
          updatedAttendanceCount = await getCurrentAttendanceCount('coach');

          roles="coachCount";
        }

        attendanceCountRef.child(roles)
            .set(updatedAttendanceCount)
            .then((_) {
          print('Updated Attendance Count in Realtime Database');
        })
            .catchError((error) {
          print('Failed to update Attendance Count: $error');
        });


       final DatabaseReference availableCoachRef = FirebaseDatabase.instance.reference().child('availableCoach');
       List<String> coachname= await getCurrentAvailableCoach();
       print('Name : $coachname');
       availableCoachRef.set(coachname)
           .then((_) {
         print('Updated Attendance Count in Realtime Database');
       })
           .catchError((error) {
         print('Failed to update Attendance Count: $error');
       });
        // attendanceDoc.set({
        //   fieldToUpdate:DateTime.now(),
        //   'date'  : currentDate,
        //
        // }, SetOptions(merge: true)).then((_) {
        //   print('Attendance document created/updated successfully');
        // }).catchError((error) {
        //   print('Failed to create/update attendance document: $error');
        // });
        // if (userSnapshot.exists) {
        //   Map<String, dynamic>? attendanceData = userSnapshot.get('attendance') as Map<String, dynamic>?;
        //   int currentAttendanceCount = attendanceData != null ? attendanceData['attendanceCount'] as int? ?? 0
        //       : 0;
        // Create a new attendance document
        // if (userSnapshot.exists) {
        //   // Retrieve the current value of inTime
        //   Map<String, dynamic>? attendanceData = userSnapshot.get('attendance') as Map<String, dynamic>?;
        //   DateTime? inTime = attendanceData != null ? attendanceData['inTime'] : null;
        //   //DocumentReference dateDoc = attendanceDoc.collection('date').doc();
        //
        // // Set attendance data++
        // attendanceDoc.set({
        //
        //   'inTime': attendanceType == "In" ? DateTime.now() : inTime,
        //   'outTime': attendanceType == "Out" ? DateTime.now() : 'outTime'
        // }).then((_) {
        //   print("Attendance registered");
        // });
        //   }


        // Determine the field to update based on the button label

        // Store the current time in the corresponding field in Firebase


        //int currentAttendanceCount = attendanceDoc != null ? attendanceDoc['attendanceCount'] as int? ?? 0 : 0;
        // Add or subtract attendance count

        // Update the attendance count in the user document
        // usersCollection
        //
        //     .set({'email': email, 'address': address}).then((_) {
        //   print("Created New account");
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => Home()));
        // }).onError((error, stackTrace) {
        //   print("Error ${error.toString()}");
        // });
        // attendanceReg.update({
        //     'attendance.attendanceCount': updatedAttendanceCount,
        //   }).then((_) {
        //     print("Attendance registered");
        //   });
        // }
      });
    }
  }

      // int count=0;
      // attendanceCollection.doc(count.toString());

      // DocumentReference attendanceReg = attendanceCollection.doc();
      // Document reference for the user


  @override
  Widget build(BuildContext context){
    DateTime currentTime=DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key:qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("Scan Result: $result", style: TextStyle(fontSize: 18),),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => handleButtonPress("In"),
                    child: Text("In"),
                  ),
                  ElevatedButton(
                    onPressed: () => handleButtonPress("Out"),
                    child: Text("Out"),
                  ),
                ],
                // children: [
                //   ElevatedButton(
                //     onPressed: () {
                //       if(result.isNotEmpty){

                // Clipboard.setData(ClipboardData(text: result));
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text("Copied to Clipboard"),
                //   ),
                // );
                // CollectionReference usersCollection =
                // FirebaseFirestore.instance.collection('users');
                // DocumentReference userDoc=usersCollection.doc(result);

                // create new attendance document
                // DocumentReference attendaceDoc=userDoc.collection('attendance').doc();

                //set attendance data
                // attendaceDoc.set({'type': "In",'timeStamp':currentTime,
                // }).then((value) {
                //   print("Attendance registered");
                // });

                // usersCollection
                //     .doc(result)
                //     .update({'attendance': "In", 'date and time': DateTime.now()}).then((_) {
                //   print("Attendance registered");
                // });
                //   }
                // },

                // ),
                //   ElevatedButton(
                //     onPressed: ()async {
                //       final Uri _url =Uri.parse(result);
                //       if(result.isNotEmpty){
                //         // await launchUrl(_url);
                //         CollectionReference usersCollection =
                //         FirebaseFirestore.instance.collection('users');
                //         DocumentReference userDoc=usersCollection.doc(result);
                //
                //         // create new attendance document
                //         DocumentReference attendaceDoc=userDoc.collection('attendance').doc();
                //
                //         //set attendance data
                //         attendaceDoc.set({'type': "Out",'timeStamp':currentTime,
                //         }).then((_) {
                //           print("Attendance registered");
                //         });
                //         // usersCollection
                //         //     .doc(result)
                //         //     .update({'attendance': "Out"}).then((_) {
                //         //   print("Attendance registered");
                //         // });
                //       }
                //     },
                //     child: Text("Out"),
                //   ),
                // ],),
              )
          ),
        ],
      ),
    );
  }
}
