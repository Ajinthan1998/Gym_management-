import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/screens/signup.dart';
import 'package:sample_app/utils/colors.dart';
import '../reusable_widgets/reusable_widgets.dart';
import 'coach/coachHome.dart';
import 'member/userNav.dart';
import 'member/forgot_pw.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _userRole = '';
    void navigateToRoleScreen() {
      if (_userRole == 'coach') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CoachScreen()));
        // Navigator.pushNamed(context, 'coach/coachHome/coachScreen');
      } else if (_userRole == 'user') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        // Navigator.pushNamed(context, 'member/userNav/Home');
      }
      // Add more roles and corresponding screens if needed
    }

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/fitness.png"),
                      SizedBox(
                        height: 30,
                      ),
                      reusableTextField("Enter Email", Icons.person_outline,
                          false, _emailTextController),
                      SizedBox(
                        height: 30,
                      ),
                      reusableTextField("Enter Password", Icons.lock_outline,
                          true, _passwordTextController),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgotPasswordPage();
                          }));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton(context, true, () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) async {
                          String? uid = value.user?.uid;
                          FirebaseFirestore _firestore =
                              FirebaseFirestore.instance;
                          DocumentSnapshot userSnapshot = await _firestore
                              .collection('users')
                              .doc(uid)
                              .get();

                          // fore role based login
                          if (userSnapshot.exists) {
                            setState(() {
                              _userRole = userSnapshot['role'];
                            });
                            navigateToRoleScreen();
                          } else {
                            // Handle user document not found error
                          }

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Home()));
                          _emailTextController.clear();
                          _passwordTextController.clear();
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      }),
                      singUpOption()
                    ],
                  )))),
    );
  }

  Row singUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signup()));
          },
          child: const Text(
            "Sign UP",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
