import 'package:flutter/material.dart';
import 'package:sample_app/screens/cookie/bottom_bar.dart';
import 'package:sample_app/screens/member/workout_page.dart';

import '../../utils/sharedPrefencesUtil.dart';
import 'workoutHistory.dart';

class CWorkout extends StatefulWidget {
  const CWorkout({Key? key}) : super(key: key);

  @override
  State<CWorkout> createState() => _CWorkoutState();
}

class _CWorkoutState extends State<CWorkout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String uid;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController
        .dispose(); // Don't forget to dispose of the TabController when it's no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   elevation: 0.0,
        //   centerTitle: true,
        //   leading: IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.arrow_back),
        //   ),
        //   title: Text(
        //     'Workouts',
        //     style: TextStyle(
        //         fontFamily: 'Varela', fontSize: 20.0, color: Color(0xFF545D68)),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //         onPressed: () {},
        //         icon: Icon(
        //           Icons.notifications_none,
        //           color: Color(0xFF545D68),
        //         ))
        //   ],
        // ),
        body: ListView(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () async {
                String uid = await SharedPreferencesUtil.getUser() ?? '';
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutHistoryPage(uid: uid)));
              },
              child: const Text('workout history'),
            ),
            Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              labelColor: Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text('Abs',
                      style: TextStyle(fontFamily: 'Varela', fontSize: 21.0)),
                ),
                Tab(
                  child: Text('Chest',
                      style: TextStyle(fontFamily: 'Varela', fontSize: 21.0)),
                ),
                Tab(
                  child: Text('Shoulder',
                      style: TextStyle(fontFamily: 'Varela', fontSize: 21.0)),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Workouts(category: "abs", uid: ""),
                  Workouts(category: "chest", uid: ""),
                  Workouts(category: "shoulder", uid: ""),
                ],
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: Color(0xFFF17532),
        //   child: Icon(Icons.fastfood),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
