import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
class CoachInfo {
  final String name;
  final String imagePath;

  CoachInfo(this.name, this.imagePath);
}
class _QRScanState extends State<QRScan>{
  String role="";
  String currentDate = DateTime.now().toString().split(' ')[0];
  String currentTime = DateTime.now().toLocal().toString().split(' ')[1].substring(0, 5);
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result ="";

  Map<String, int> extractTimeComponents(String timeString) {
    List<String> timeParts = timeString.split(':');

    return {
      'hour': int.parse(timeParts[0]),
      'minute': int.parse(timeParts[1]),
    };
  }

  Duration calculateWorkingHours(List<Map<String, dynamic>> attendanceData) {
    Duration totalWorkingHours = Duration.zero;

    for (var entry in attendanceData) {
      if (entry['intime'] != null && entry['outtime'] != null) {
        Map<String, int> intimeComponents = extractTimeComponents(entry['intime']);
        Map<String, int> outtimeComponents = extractTimeComponents(entry['outtime']);

        DateTime intime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          intimeComponents['hour']!,
          intimeComponents['minute']!,
        );

        DateTime outtime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          outtimeComponents['hour']!,
          outtimeComponents['minute']!,
        );
        totalWorkingHours += outtime.difference(intime);
      }
    }

    return totalWorkingHours;
  }

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
          .where('date', isEqualTo: currentDate.toString())
          .where('availability',isEqualTo: "Yes")
          .get();
      totalCount += attendanceSnapshot.docs.length;
    }
    return totalCount;
  }

  Future<List<String>> getCurrentAvailableCoachIds() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "coach")
        .get();

    List<String> coachIds = [];

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('attendance')
          .where('date', isEqualTo: currentDate.toString())
          .where('availability', isEqualTo: "Yes")
          .get();

      if (attendanceSnapshot.docs.isNotEmpty) {
        String userId = userDoc.id; // Fetch the user ID of available coach
        coachIds.add(userId);
      }
    }

    return coachIds;
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

        DocumentReference attendanceDoc = userDoc.collection('attendance').doc(currentDate);
        //String fieldToUpdate = attendanceType == 'In' ? 'intime' : 'outtime';



        // if (attendanceType == 'In') {
        //   await attendanceDoc.set({
        //     'intime': currentTime,
        //     'availability': "Yes",
        //     'date'  : currentDate,
        //   }, SetOptions(merge: true)).then((_){
        //     print('Attendance document created/updated successfully');
        //   }).catchError((error) {
        //     print('Failed to create/update attendance document: $error');
        //   });
        // } else {
        //   await attendanceDoc.set({
        //     'outtime': currentTime,
        //     'availability':"No"
        //   }, SetOptions(merge: true)).then((_){
        //     print('Failed to create/update attendance document');
        //   });
        // }

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

       // if (role == 'coach') {
       //   DocumentSnapshot attendanceSnapshot = await attendanceDoc.get();
       //   List<Map<String, dynamic>> attendanceData = [];
       //   if (attendanceSnapshot.exists) {
       //     Map<String, dynamic>? data = attendanceSnapshot.data() as Map<String, dynamic>?;
       //
       //     if (data != null && data['attendance_data'] is List) {
       //       List<dynamic> dataList = data['attendance_data'] as List<dynamic>;
       //       attendanceData = dataList.map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>)).toList();
       //     }
       //   }
       //
       //   bool isCheckedIn = false;
       //   if (attendanceData.isNotEmpty) {
       //     Map<String, dynamic> lastEntry = attendanceData.last;
       //       isCheckedIn =
       //           lastEntry['intime'] != null && lastEntry['outtime'] == null;
       //     }
       //
       //
       //   DateTime currentTimeDateTime = DateTime.now();
       //
       //   if (isCheckedIn) {
       //     // The coach is already checked in, so check if the next 'intime' is greater than the previous 'outtime'
       //     if (attendanceData.length < 2 || attendanceData.last['outtime'] == null || currentTimeDateTime.isAfter(DateTime.parse(attendanceData.last['outtime']))) {
       //       // The next 'intime' value is valid, so add the 'outtime' value when the "out button" is pressed
       //       if (attendanceType == 'Out') {
       //         attendanceData.last['outtime'] = currentTime;
       //       }
       //     } else {
       //       // The next 'intime' value is not valid as it is before the previous 'outtime'
       //       // You may show an error message or handle this scenario accordingly.
       //     }
       //   } else {
       //     // The coach is not checked in, so add a new entry with 'intime' when the "in button" is pressed
       //
       //     attendanceData.add({
       //       'intime': currentTime,
       //       'outtime': null, // Use null for initial 'outtime' value
       //       'date': currentDate,
       //       'availability': "Yes",
       //     });
       //   }
       //
       //
       //   // Update the 'attendance_data' field in Firestore
       //   await attendanceDoc.set({
       //     'attendance_data': attendanceData,
       //   }, SetOptions(merge: true)).then((_) {
       //     print('Attendance document created/updated successfully');
       //   }).catchError((error) {
       //     print('Failed to create/update attendance document: $error');
       //   });
       // }
       if (role == 'coach') {
         DocumentSnapshot attendanceSnapshot = await attendanceDoc.get();
         List<Map<String, dynamic>> attendanceData = [];
         if (attendanceSnapshot.exists) {
           Map<String, dynamic>? data = attendanceSnapshot.data() as Map<String, dynamic>?;

           if (data != null && data['attendance_data'] is List) {
             List<dynamic> dataList = data['attendance_data'] as List<dynamic>;
             attendanceData = dataList.map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>)).toList();
           }
         }

         bool isCheckedIn = false;
         if (attendanceData.isNotEmpty) {
           Map<String, dynamic> lastEntry = attendanceData.last;
             isCheckedIn = lastEntry['intime'] != null && lastEntry['outtime'] == null;

         }

         DateTime currentTimeDateTime = DateTime.now();

         if (isCheckedIn) {
           // The coach is already checked in, so check if the next 'intime' is greater than the previous 'outtime'
           if (attendanceData.length < 2 || attendanceData.last['outtime'] == null || currentTimeDateTime.isAfter(DateTime.parse(attendanceData.last['outtime']))) {
             // The next 'intime' value is valid, so add the 'outtime' value when the "out button" is pressed
             if (attendanceType == 'Out') {
               attendanceData.last['outtime'] = currentTime;
             }
           } else {
             // The next 'intime' value is not valid as it is before the previous 'outtime'
             // You may show an error message or handle this scenario accordingly.
           }
         } else {
           // The coach is not checked in, so add a new entry with 'intime' when the "in button" is pressed
           if (attendanceType == 'In') {
             attendanceData.add({
               'intime': currentTime,
               'outtime': null, // Use null for initial 'outtime' value
             });
           }
         }

         // Calculate overall 'availability' status based on the last entry
         bool isAvailable = attendanceData.isNotEmpty && attendanceData.last['outtime'] == null;

         String? currentUserUID = FirebaseAuth.instance.currentUser?.uid; // Replace with your method to get the current coach's ID

         // Retrieve the current coach's name from the userCollection using their ID
         DocumentSnapshot coachSnapshot = await FirebaseFirestore.instance
             .collection('users')
             .doc(currentUserUID)
             .get();

         if (coachSnapshot.exists) {
           String currentCoachName = coachSnapshot['coachName'] as String;

           // Get the count of users trained by the coach on the current day
           QuerySnapshot userSnapshot = await FirebaseFirestore.instance
               .collection('users')
               .where('coachName', isEqualTo: currentCoachName) // Replace with the actual field name for coach's name
               .get();

           int trainedUsersCount = userSnapshot.docs.length;
           List<String> trainedUsernames = userSnapshot.docs
               .map((doc) => doc['username'] as String)
               .toList();

           await attendanceDoc.set({
             'date': currentDate,
             'availability': isAvailable ? "Yes" : "No",
             'attendance_data': attendanceData,
             'trainedUsersCount': trainedUsersCount,
             'trainedUsernames': trainedUsernames,
           }, SetOptions(merge: true)).then((_) {
             print('Attendance document created/updated successfully');
           }).catchError((error) {
             print('Failed to create/update attendance document: $error');
           });

         Duration totalWorkingHours = calculateWorkingHours(attendanceData);
         int hours = totalWorkingHours.inHours;
         int minutes = totalWorkingHours.inMinutes % 60;
         print('Total Working Hours: $hours:${minutes.toString().padLeft(2, '0')}');

         // Duration totalWorkingHoursPerDay = calculateWorkingHours(attendanceData);

         // Update the 'totalWorkingHours' field in Firestore
         await attendanceDoc.set({
           'totalWorkingHours':'$hours:${minutes.toString().padLeft(2, '0')}', // Store the total minutes
         }, SetOptions(merge: true)).then((_) {
           print('Total working hours updated successfully');
         }).catchError((error) {
           print('Failed to update total working hours: $error');
         });
       }
       }
       else if (role == 'user') {
         DocumentSnapshot attendanceSnapshot = await attendanceDoc.get();
         Map<String, dynamic>? attendanceData = attendanceSnapshot.data() as Map<String, dynamic>?;

         if (attendanceData != null) {
           // Check if 'intime' is already set, and only set it if it's not already present
           if (attendanceData['intime'] == null) {
             if (attendanceType == 'In') {
               await attendanceDoc.set({
                 'intime': currentTime,
                 'availability': "Yes",
                 'date': currentDate,
               }, SetOptions(merge: true)).then((_) {
                 print('Attendance document created/updated successfully');
               }).catchError((error) {
                 print('Failed to create/update attendance document: $error');
               });
             }
           } else {
             // Check if 'outtime' is already set, and only set it if it's not already present and 'intime' < 'outtime'
             if (attendanceData['outtime'] == null) {
               if (attendanceType == 'Out') {
                 await attendanceDoc.set({
                   'outtime': currentTime,
                   'availability': "No",
                 }, SetOptions(merge: true)).then((_) {
                   print('Attendance document created/updated successfully');
                 }).catchError((error) {
                   print('Failed to create/update attendance document: $error');
                 });
               } else {
                 // Show an error message or handle the scenario where 'outtime' should be after 'intime'
               }
             } else {
               // 'outtime' is already set, so no further action needed
             }
           }
         } else {
           // If the attendance document doesn't exist, set 'intime' for the first time
           if (attendanceType == 'In') {
             await attendanceDoc.set({
               'intime': currentTime,
               'availability': "Yes",
               'date': currentDate,
             }, SetOptions(merge: true)).then((_) {
               print('Attendance document created/updated successfully');
             }).catchError((error) {
               print('Failed to create/update attendance document: $error');
             });
           }
         }


       }


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
       List<String> coachIds = await getCurrentAvailableCoachIds();
       print('Names: $coachIds');
       //
       // List<Map<String, String>> serializedCoaches = coachIds.map((coachId) {
       //   return {'uid': coachId};
       // }).toList();


       availableCoachRef
           .set(coachIds)
           .then((_) {
         print('Updated available coaches in Realtime Database');
       })
           .catchError((error) {
         print('Failed to update available coaches: $error');
       });
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
