import 'dart:io';

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sample_app/screens/member/coachSelection.dart';
import 'package:sample_app/screens/member/reviewScreen.dart';

import '../../models/coach.dart';
import '../../models/review.dart';
import '../../models/PackageBox.dart';
import 'PackageDetails.dart';
import 'availablepackages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  String? email;
  String? username;
  String? imageUrl;
  Stream<int>? attendanceCountStream;
  late Stream<List<Object>> availablecoachStream;
  List<String> usernames = [];

  DatabaseReference attendanceCountRef = FirebaseDatabase.instance
      .reference()
      .child('attendanceCount')
      .child('userCount');

  DatabaseReference available =
      FirebaseDatabase.instance.reference().child('availableCoach');

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
        data = (event.snapshot.value as List<dynamic>).cast<Object>();
      }
      return data;
    });
  }

  Future<List<Coach>> _loadCoaches(List<String> coachIds) async {
    List<Coach> coaches = [];

    for (final String coachId in coachIds) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(coachId)
          .get();

      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;

        coaches.add(Coach(
          uid: snapshot.id,
          email: data['email'] ?? '',
          username: data['username'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        ));
      }
    }

    return coaches;
  }

  Future<List<HomeReview>> _loadReview() async {
    List<HomeReview> reviews = [];

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('gymReviews')
        .limit(5)
        .get();

    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

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
              color: Colors.white24, // Change the color to red
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

            StreamBuilder<int>(
              stream: attendanceCountStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int attendanceCount = snapshot.data!;
                  return Align(
                    alignment: Alignment.topRight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          // Adjust the height as desired
                          child: CircularSeekBar(
                            width: double.infinity,
                            height: 150,
                            progress: attendanceCount.toDouble(),
                            maxProgress: 20,
                            minProgress: 0,
                            barWidth: 10,
                            startAngle: 90,
                            sweepAngle: 360,
                            strokeCap: StrokeCap.butt,
                            progressColor: Color(0xFFB71C1C),
                            innerThumbRadius: 5,
                            innerThumbStrokeWidth: 3,
                            innerThumbColor: Colors.white,
                            outerThumbRadius: 10,
                            outerThumbStrokeWidth: 10,
                            outerThumbColor: Color(0xFFB71C1C),
                            animation: true,
                          ),
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              Text(
                                'Current Crowd',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 20, // Adjust the width as desired
                                height: 40, // Adjust the height as desired
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    attendanceCount != null
                                        ? '$attendanceCount'
                                        : 'N/A',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                    child: SpinKitWaveSpinner(
                      color: Colors.white,
                      size: 50.0, // Adjust the size as desired
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: StreamBuilder<List<Object>>(
                  stream: availablecoachStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Object> data = snapshot.data!;
                      List<String> coachIds = data.cast<String>();
                      if (data.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Available Coaches:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 6,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(
                                      10.0,
                                      10.0,
                                    ), //Offset
                                    blurRadius: 3.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                ],
                              ), // Adjust the height as needed
                              child: FutureBuilder<List<Coach>>(
                                future: _loadCoaches(coachIds),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else {
                                    List<Coach> coaches = snapshot.data ?? [];
                                    return GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        mainAxisExtent: 130,
                                        crossAxisSpacing: 3.0,
                                        mainAxisSpacing: 3.0,
                                      ),
                                      itemCount: coaches.length,
                                      itemBuilder: (context, index) {
                                        Coach coach = coaches[index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(coach.imageUrl),
                                              radius: 50,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              coach.username,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No available coaches',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
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
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff9b1616),
              ),
              child: Text("Select Your Coach Here",
              style: TextStyle(
                 fontSize: 20,
               ),),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoachSelectionScreen()));
              },
            ),
            SizedBox(height: 20),
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
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
                    padding: const EdgeInsets.all(16.0),
                    // scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: new Offset(-10.0, 10.0),
                                blurRadius: 20.0,
                                spreadRadius: 3.0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person, color: Colors.white),
                              Text(
                                review.username,
                                style:
                                    TextStyle(height: 2, color: Colors.white),
                              ),
                              Text(
                                review.review,
                                style:
                                    TextStyle(height: 2, color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Select Packages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('packages').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                List<Widget> packageButtons = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  String packageName = data['packageName'] ?? '';
                  String duration = data['duration'] ?? '';
                  String imageUrl = data['url'] ??
                      ''; // Adjust the field name based on your actual Firestore structure

                  return InkWell(
                    onTap: () {
                      // Handle the onTap event for the package box here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageDetailsPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width:
                            300, // Set the desired width for each package box
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white24,
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white24,
                              // offset: Offset(10, -10),
                              blurRadius: 2.0,
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.7),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    packageName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    duration + ' Month',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList();

                return Container(
                  height: 200, // Set the desired height for the container
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: packageButtons,
                    ),
                  ),
                );
              },
            ),
            Review(currentUser: currentUser),

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
