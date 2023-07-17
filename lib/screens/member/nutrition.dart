import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NutritionItem {
  String id;
  String foodTime;
  String food;
  String category;
  String day;
  int calories;

  NutritionItem({
    required this.id,
    required this.foodTime,
    required this.food,
    required this.category,
    required this.day,
    required this.calories,
  });
}

class NutritionChart extends StatelessWidget {
  String? uid;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    var cat;


    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now);


    return Scaffold(
      appBar: AppBar(
        title: Text(
        'Nutrition Chart',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black, // Set your desired background color
      elevation: 0,
    ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('nutrition_chart').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              CollectionReference userCollectionsRef =
              FirebaseFirestore.instance.collection('users').doc(uid).collection('bmi');

              return FutureBuilder<QuerySnapshot>(
                future: userCollectionsRef.orderBy('time', descending: true).limit(1).get(),
                builder: (context, bmiSnapshot) {
                  if (bmiSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  var lastBmiDocument = bmiSnapshot.data?.docs.isNotEmpty ?? false
                      ? bmiSnapshot.data!.docs[0]
                      : null;


                  if (lastBmiDocument != null) {
                    cat = lastBmiDocument['category'];
                    cat = cat.trim();
                    // for (var i = 0; i < cat.length; i++) {
                    //   print('Character at index $i: ${cat[i]} (${cat.codeUnitAt(i)})');
                    // }
                    // print('Length of catyy: ${cat.length}');
                    // print('Category: $cat');
                  } else {
                    print('No BMI documents found.');
                  }
                  print('Category: $cat');


                  List<NutritionItem> items = snapshot.data!.docs
                      .where((doc) {
                    final category = doc['category'];
                    // print('Category in document: $category');
                    // print('Category to match: $c');
                    // print('Length of cat: ${cat.length}');
                    // print('Length of category: ${category.length}');
                    return doc['day'] == dayName && category != null && category == cat;
                  })
                      .map((doc) {
                    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
                    return NutritionItem(
                      id: doc.id,
                      foodTime: data!['foodTime'] != null ? data['foodTime'] : '',
                      food: data['food'] != null ? data['food'] : '',
                      category: data['category'] != null ? data['category'] : '',
                      day: data['day'] != null ? data['day'] : '',
                      calories: data['calories'] != null ? data['calories'] : 0,
                    );
                  }).toList();


                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(

                      child: Column(
                        children: [
                          DataTable(
                            horizontalMargin: 16,
                            dataRowMinHeight: 10,
                            columnSpacing: 16,
                            columns: [
                              DataColumn(label: Text('Food Time')),
                              DataColumn(label: Text('Food')),
                              DataColumn(label: Text('Calories')),
                              DataColumn(label: Text('Category')),
                              DataColumn(label: Text('Day')),
                            ],

                            rows: items.map((item) {
                              List<Widget> foodWidgets = [];
                              item.food.split(' + ').forEach((foodItem) {
                                foodWidgets.add(Text(
                                  foodItem,
                                  style: TextStyle(
                                    color: Colors.white, // Set your desired color
                                    //...
                                  ),
                                ));
                              });
                              return DataRow(
                                  color: MaterialStateColor.resolveWith((states) => Colors.red),
                                  cells: [
                                DataCell( Text(
                                  item.foodTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),),
                                DataCell( Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: foodWidgets,
                                ),),
                                DataCell(Text(item.calories.toString())),
                                DataCell(Text(item.category.toString(),style: TextStyle(
                                  color: Colors.white, // Set your desired color
                                  //...
                                ),)),
                                DataCell(Text(item.day.toString())),
                              ]);
                            }).toList(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suggestions",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fat foods',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/fats.jpg',
                                          width: 150,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Protein foods',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/protein.jpeg',
                                          width: 150,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Grains foods',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/grains.jpg',
                                          width: 150,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Fruits & Vegetables foods',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/Fruits_and_vegetables.jpg',
                                          width: 150,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}