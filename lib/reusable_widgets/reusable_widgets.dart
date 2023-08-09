import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {Widget? suffixIcon}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white12.withOpacity(0.1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      suffixIcon: suffixIcon,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Color(0xff9b1616);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

// void uid() {
//   String? email;
//   String? address;
//   String? uid;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   uid = user?.uid;
//
//   if (uid != null) {
//     DocumentReference userDocRef =
//         FirebaseFirestore.instance.collection('users').doc(uid);
//
//     userDocRef.get().then((DocumentSnapshot documentSnapshot) {
//       // Map<String, dynamic> userData = documentSnapshot.data!.data()
//       Map<String, dynamic>? userData =
//           documentSnapshot.data() as Map<String, dynamic>?;
//       setState(() {
//         email = userData!['email'];
//         address = userData['address'];
//       });
//     });
//   }
// }

class UserDataFetcher {
  static void fetchUserDataAndUpdateState(BuildContext context,
      Function(String? email, String? address) setStateCallback) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(uid);

      userDocRef.get().then((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic>? userData =
        documentSnapshot.data() as Map<String, dynamic>?;

        setStateCallback(userData?['email'], userData?['address']);
      });
    }
  }
}
