import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackageDetailsPage extends StatelessWidget {
   final String packageId;
   final String duration;


  const PackageDetailsPage({
    required this.packageId,
    required this.duration,

    // Add any other necessary parameters
  });


  Future<void> addPackageToFirestore(
      String packageId,
      String duration,

      ) async {
    final CollectionReference packagesRef =
    FirebaseFirestore.instance.collection('packages');
    final DocumentSnapshot packageDoc = await packagesRef.doc(packageId).get();

    if (packageDoc.exists) {
      // Package already exists, perform desired actions
      // For example, show a message that the package is already added
      print('Package already added.');
    } else {
      // Package does not exist, add it to Firestore
      await packagesRef.doc(packageId).set({
        'duration': duration,

        // Add any other necessary fields
      });
      // Perform any additional actions upon successful addition
      // For example, show a success message
      print('Package added successfully!');
    }
  }

   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Package Details'),
       ),
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(
             'Package: $duration',
             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 20),
           Image.asset(
             'assets/images/package_image.jpg', // Replace with your package image asset path
             height: 200,
             width: 200,
             fit: BoxFit.cover,
           ),
           SizedBox(height: 20),
           Text(
             'Price: \$99.99', // Replace with the actual price
             style: TextStyle(fontSize: 18),
           ),
           SizedBox(height: 20),
           Text(
             'Workouts:',
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 10),
           Text(
             'Workout 1',
             style: TextStyle(fontSize: 16),
           ),
           Text(
             'Workout 2',
             style: TextStyle(fontSize: 16),
           ),
           Text(
             'Workout 3',
             style: TextStyle(fontSize: 16),
           ),
           ElevatedButton(
             onPressed: () {
               addPackageToFirestore(packageId, duration);
             },
             child: Text('Add to Firestore'),
           ),
         ],
       ),
     );
   }

}
