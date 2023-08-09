import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../member/qr_scan.dart';
import '../qr_screen.dart';
import '../signin.dart';
import 'addNewUser.dart';

class ReceptionistScreen extends StatefulWidget {
  const ReceptionistScreen({Key? key}) : super(key: key);

  @override
  State<ReceptionistScreen> createState() => _ReceptionistScreenState();
}

class _ReceptionistScreenState extends State<ReceptionistScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens2 = [
    ReceptionistHomeScreen(),
    AddNewUser(),
    ReceptionistProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("JK Receptionist"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => QRScan()));
                },
                icon: Icon(Icons.qr_code))
          ],
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens2,
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16),
              gap: 10,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.add,
                  text: "Add new user",
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}

class ReceptionistHomeScreen extends StatefulWidget {
  const ReceptionistHomeScreen({Key? key}) : super(key: key);

  @override
  State<ReceptionistHomeScreen> createState() => _ReceptionistHomeScreenState();
}

class _ReceptionistHomeScreenState extends State<ReceptionistHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Receptionist home',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// class ReceptionistAddUser extends StatefulWidget {
//   const ReceptionistAddUser({Key? key}) : super(key: key);
//
//   @override
//   State<ReceptionistAddUser> createState() => _ReceptionistAddUserState();
// }
//
// class _ReceptionistAddUserState extends State<ReceptionistAddUser> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Center(
//           child: Text(
//             'add user Page',
//             style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ReceptionistProfileScreen extends StatefulWidget {
  const ReceptionistProfileScreen({Key? key}) : super(key: key);

  @override
  State<ReceptionistProfileScreen> createState() =>
      _ReceptionistProfileScreenState();
}

class _ReceptionistProfileScreenState extends State<ReceptionistProfileScreen> {
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
            'Receptionist Profile Page',
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
