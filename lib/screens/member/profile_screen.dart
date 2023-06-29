import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../signin.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Text(email ?? ""),
//           Text(
//             'Profile Page',
//             style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
//           ),
//           ElevatedButton(
//             child: Text("Logout"),
//             onPressed: () {
//               FirebaseAuth.instance.signOut().then((value) {
//                 print("Signed Out");
//                 FirebaseAuth.instance.setPersistence(Persistence.NONE);
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => Signin()));
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            'Profile Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
