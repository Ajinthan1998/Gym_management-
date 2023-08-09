import 'package:flutter/material.dart';

import '../../utils/sharedPrefencesUtil.dart';
import 'ownWorkouts.dart';
import 'workout_page.dart';

class SeeOwnWorkouts extends StatelessWidget {
  const SeeOwnWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userid = 'aaa';
    return Scaffold(
        appBar: AppBar(
          title: Text("Own workouts"),
        ),
        body: GridView.count(
          primary: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
          children: <Widget>[
            Container(
              height: 5,
              color: Colors.blue,
              child: Text(userid),
            ),
            OwnWorkouts(category: "abs"),
            Container(
              height: 5,
              color: Colors.blue,
            ),
            OwnWorkouts(category: "chest"),
            Container(
              height: 5,
              color: Colors.blue,
            ),
            OwnWorkouts(category: "shoulder"),
          ],
        )

        // ListView(
        //   children: [
        //     Text(
        //       "hello",
        //       style: TextStyle(color: Colors.white70),
        //     ),
        //     Workouts(category: "abs", uid: ""),
        //     Workouts(category: "chest", uid: ""),
        //     Workouts(category: "shoulder", uid: ""),
        //   ],
        // ),
        );
  }
}
