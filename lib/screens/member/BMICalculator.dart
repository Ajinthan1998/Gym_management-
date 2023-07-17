import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/screens/member/prog.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double _height = 170.0;
  double _weight = 75.0;
  int bmi = 0;
  String _condition = "Select Data";

  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  String? email;
  String? address;
  String? uid;
  get bmiValue => bmi;
  String curdate = DateTime.now().toString().split(' ')[0];
  @override
  Widget build(BuildContext context) {
    // final bool isAdult = true;
    Size size = MediaQuery.of(context).size;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    // email = user?.email;

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
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Calculator"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xfff60000)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: InkWell(
                                  onTap: () {
                                    // Perform actions when the image button is tapped
                                  },
                                  child: Text(
                                    "BMI",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Icon(
                                  //   Icons.account_circle_rounded,
                                  //   size: 80,
                                  //   color: Colors.black,
                                  // ),
                                ),
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(email ?? "", style: TextStyle(
                            //       fontSize: 20, color: Colors.white),),
                            // ),
                            // SizedBox(width: 20),
                            //
                            // Container(
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(40.0),
                            //     child: InkWell(
                            //       onTap: () {
                            //         // Perform actions when the image button is tapped
                            //       },
                            //       child: Image.asset(
                            //         "assets/images/img_1.png",
                            //         width: 80,
                            //         height: 80,
                            //         fit: BoxFit.cover,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const Text('Female',style: TextStyle(fontSize: 30),),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Text(
                            "$bmi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Condition : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "$_condition",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xf2ffffff),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                  width: double.infinity,
                  // height: 800,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      // Text(
                      //   "Type height and weight",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 25.0,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      SizedBox(height: size.height * 0.02),
                      RichText(
                        text: TextSpan(
                          text: "Height : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "$_height cm",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 300,
                              child: TextField(
                                controller: _heightController,
                                // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter height in cm',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 60),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),

                                onChanged: (value) {
                                  setState(() {
                                    _height = double.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                            ),

                            // Container(
                            //   child: RawMaterialButton(
                            //     fillColor: Color(0xf2b0a3a3),
                            //     shape: CircleBorder(),
                            //     onPressed: () {
                            //       setState(() {
                            //         if (_height < 300) {
                            //           _height++;
                            //         }
                            //       });
                            //     },
                            //     child: Icon(
                            //       Icons.add,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      RichText(
                        text: TextSpan(
                          text: "Weight : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "$_weight kg",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(
                            //   child: RawMaterialButton(
                            //     fillColor: Color(0xf2b0a3a3),
                            //     shape: CircleBorder(),
                            //     onPressed: () {
                            //       setState(() {
                            //         if (_weight > 5) {
                            //           _weight--;
                            //         }
                            //       });
                            //     },
                            //     child: Icon(
                            //       Icons.remove,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width:
                                  300, // Set the desired width for the TextField
                              child: TextField(
                                controller:
                                    _weightController, // TextEditingController to manage the input value
                                // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter weight in kg',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 60),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (value) {
                                  // Update the weight value when the TextField value changes
                                  setState(() {
                                    _weight = double.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                            ),
                            // Container(
                            //   child: RawMaterialButton(
                            //     fillColor: Color(0xf2b0a3a3),
                            //     shape: CircleBorder(),
                            //     onPressed: () {
                            //       setState(() {
                            //         if (_weight < 400) {
                            //           _weight++;
                            //         }
                            //       });
                            //     },
                            //     child: Icon(
                            //       Icons.add,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),
                      Container(
                        // width: size.width * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff9b1616),
                              ),
                              child: Text(
                                "Calculate",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  bmi = (_weight /
                                          ((_height / 100) * (_height / 100)))
                                      .round()
                                      .toInt();
                                  // if (isAdult == true) {
                                  if (bmi > 18.5 && bmi <= 25) {
                                    _condition = " Normal";
                                  } else if (bmi > 25 && bmi <= 30) {
                                    _condition = " Overweight";
                                  } else if (bmi > 30) {
                                    _condition = " Obesity";
                                  } else {
                                    _condition = " Underweight";
                                  }

                                  // } else {
                                  //   if (bmi < 5) {
                                  //     _condition = " Underweight";
                                  //   } else if (bmi >= 5 && bmi < 85) {
                                  //     _condition = " Healthy";
                                  //   } else if (bmi >= 85 && bmi < 95) {
                                  //     _condition = " Overweight";
                                  //   } else if (bmi >= 95 && bmi < 99) {
                                  //     _condition = " Obesity Class I";
                                  //   } else {
                                  //     _condition = " Obesity Class II";
                                  //   }
                                  // }
                                });
                                CollectionReference usersCollection =
                                    FirebaseFirestore.instance
                                        .collection('users');
                                DocumentReference userDoc =
                                    usersCollection.doc(uid);
                                DocumentReference bmiDoc =
                                    userDoc.collection('bmi').doc(curdate);
                                bmiDoc.set({
                                  'value': bmi,
                                  'time': DateTime.now(),
                                  'category': _condition,
                                }).then((_) {
                                  print("Created New account");
                                }).onError((error, stackTrace) {
                                  print("Error ${error.toString()}");
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xE4541414),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChartScreen()));
                                },
                                child: Text("BMI Chart"),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xE4541414),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             NutritionChart()));
                                  },
                                  child: Text("Diet Level")),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6F00FF),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => TimerPage()));
                        },
                        child: Text("Timer"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
