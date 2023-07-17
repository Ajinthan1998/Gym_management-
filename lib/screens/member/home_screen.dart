import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sample_app/screens/member/reviewScreen.dart';

import '../../models/review.dart';
import 'PackageBox.dart';
import 'PackageDetails.dart';
import 'availablepackages.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<int>? attendanceCountStream;
  late Stream<List<Object>> availablecoachStream;
  List<String> usernames = [];
  DatabaseReference attendanceCountRef = FirebaseDatabase.instance.reference()
      .child('attendanceCount')
      .child('userCount');

  DatabaseReference available = FirebaseDatabase.instance.reference()
      .child('availableCoach');

  final User currentUser = FirebaseAuth.instance.currentUser!;
  double _rating = 0;

  void initState() {
    super.initState();
    attendanceCountStream = attendanceCountRef.onValue.map((event) {
      return event.snapshot.value as int? ?? 0;
    });
    availablecoachStream = available.onValue.map((event) {
      List<Object> data = [];
      if (event.snapshot.value != null) {
        // Convert the dynamic value to a List<Object>
        data = (event.snapshot.value as List<dynamic>).cast<Object>();
      }
      return data;
    });
  }

  Future<List<HomeReview>> _loadReview() async {
    List<HomeReview> reviews = [];

    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('gymReviews').limit(3).get();

    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data =
      doc.data() as Map<String, dynamic>;

      reviews.add(HomeReview(
        rating: data['rating'].toString(),
        review: data['review'] ?? '',
        username: data['username'] ?? '',
      ));
    }

    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              // color: Colors.red, // Change the color to red
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 200,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/chest.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/workout.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/abs.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Add more Container widgets for additional images
                ],
              ),
            ),

            StreamBuilder<List<Object>>(
              stream: availablecoachStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Object> data = snapshot.data!;
                  if (data.isNotEmpty) {
                    return Center(

                        child: Column(
                          children: [
                            Text('Available Coaches:'),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                String coachName = data[index].toString();
                                return ListTile(
                                  title: Text(coachName),
                                );
                              },
                            ),
                          ],
                        ),


                    );
                  } else {
                    return Center(
                      child: Text('No available coaches'),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            StreamBuilder<int>(
              stream: attendanceCountStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int attendanceCount = snapshot.data!;
                  return Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1, // Set value to 1 for a full circle
                          strokeWidth: 5, // Adjust the stroke width as desired
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          backgroundColor: Colors.grey[200],
                        ),
                        Text(
                          '$attendanceCount',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),

            SizedBox(height: 20),
            Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<HomeReview>>(
              future: _loadReview(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final reviews = snapshot.data ?? [];
                  return GridView.builder(
                    // scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person),
                            Text(review.username),
                            Text('Review: ${review.review}'),
                            RatingBarIndicator(
                              rating: double.parse(review.rating),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
             Review(currentUser: currentUser),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle the onTap event for package1
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageDetailsPage(
                              packageId: 'package1',
                              duration: '1 Month',
                            ),
                          ),
                        );
                      },
                      child: PackageBox(
                        duration: '1 Month',
                        backgroundColor: Colors.purple,
                        shadowColor: Colors.black,
                        packageId: 'package1',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the onTap event for package2
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageDetailsPage(
                              packageId: 'package2',
                              duration: '3 Months',
                            ),
                          ),
                        );
                      },
                      child: PackageBox(
                        duration: '3 Months',
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.black,
                        packageId: 'package2',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the onTap event for package3
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageDetailsPage(
                              packageId: 'package3',
                              duration: '4 Months',
                            ),
                          ),
                        );
                      },
                      child: PackageBox(
                        duration: '4 Months',
                        backgroundColor: Colors.green,
                        shadowColor: Colors.black,
                        packageId: 'package3',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the onTap event for package4
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageDetailsPage(
                              packageId: 'package4',
                              duration: '6 Months',
                            ),
                          ),
                        );
                      },
                      child: PackageBox(
                        duration: '6 Months',
                        backgroundColor: Colors.red,
                        shadowColor: Colors.black,
                        packageId: 'package4',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //     Container(
         //     child: SingleChildScrollView(
         //       scrollDirection: Axis.horizontal,
         //       child: Container(
         //
         //         child: ElevatedButton(
         //           onPressed: () {
         //             MaterialPageRoute(
         //               builder: (context) => PackageDetailsPage(packageId: '', duration: ,),
         //             );
         //           },
         //           child: Column(
         //             children: [
         //               Container(
         //                 child: Row(
         //                   children: [
         //                     AvailablePackagePage(duration:"1 Month",packageId: "package1",color: Colors.purple,),
         //                     AvailablePackagePage(duration:"3 Month",packageId: "package1",color: Colors.blue,),
         //                     AvailablePackagePage(duration:"4 Month",packageId: "package2",color: Colors.green,),
         //                     AvailablePackagePage(duration:"6 Month",packageId: "package3",color: Colors.red,),
         //                   ],
         //                 ),
         //               ),
         //             ],
         //           ),
         //         ),
         //       ),
         //
         //     ),
         // ),
  //        InkWell(
  //         onTap: () {
  //     // Navigate to the available package page
  //     Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AvailablePackagePage()),
  //   );
  // },
  //           child: Container(
  //             width: 120,
  //             height: 120,
  //               decoration: BoxDecoration(
  //               color: Colors.red,
  //               borderRadius: BorderRadius.circular(10),
  //               ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //               Icons.wallet_giftcard,
  //               size: 50,
  //               color: Colors.white,
  //               ),
  //           SizedBox(height: 10),
  //             Text(
  //             'Packages',
  //               style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //           ),
  //           ),
  //           ),
          ],
        ),
      ),
    );
  }
}
