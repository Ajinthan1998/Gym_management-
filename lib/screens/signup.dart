import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors.dart';
import 'member/userNav.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _roleTextController = TextEditingController();
  TextEditingController _dobTextController = TextEditingController();
  // TextEditingController _joinedDateTextController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordMatch = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.mail_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password",
                  Icons.lock_outlined,
                  !_isPasswordVisible,
                  _passwordTextController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password again",
                  Icons.lock_outlined,
                  !_isPasswordVisible,
                  _confirmPasswordTextController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                if (!_isPasswordMatch)
                  const SizedBox(
                    height: 20,
                    child: Text(
                      "Passwords do not match",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Address", Icons.home, false, _addressTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Phone number", Icons.lock_outlined, false,
                    _phoneNumberTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter role", Icons.lock_outlined, false,
                    _roleTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter DoB('YYYY-MM-DD')", Icons.lock_outlined, false,
                    _dobTextController),
                // const SizedBox(
                //   height: 20,
                // ),
                // reusableTextField("Enter Joined date", Icons.lock_outlined, false,
                //     _joinedDateTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text
                       )
                      .then((value) {
                    String? uid = value.user?.uid;
                    String? email = value.user?.email;
                    String? username = _userNameTextController.text;
                    String address = _addressTextController.text;
                    String phone_no = _phoneNumberTextController.text;
                    String role = _roleTextController.text;
                    String dob = _dobTextController.text;
                    // String joined_date = _joinedDateTextController.text;

                    //Save the user data to the firestore db
                    CollectionReference usersCollection =
                        FirebaseFirestore.instance.collection('users');
                    usersCollection
                        .doc(uid)
                        .set({'username':username,'email': email, 'address': address,'phone_no':phone_no,'role':role,'dob':dob}).then((_) {
                      print("Created New account");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  });
                })
              ],
            ),
          ))),
    );
  }
}
