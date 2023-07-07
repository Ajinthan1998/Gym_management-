import 'package:flutter/material.dart';

import '../../utils/imageTile.dart';
import '../../utils/workout_type.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // list of workout types
  final List workoutType = [
    ['Chest', true],
    ['Abs', false],
    ['Shoulders', false],
  ];

  void workoutTypeSelected(int index) {
    setState(() {
      for (int i = 0; i < workoutType.length; i++) {
        workoutType[i][1] = false;
      }
      workoutType[index][1] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Workout Page',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 25,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image.asset("assets/images/workout.jpg"),
              color: Colors.black,
              height: 150,
            ),
          ),

          //horizontal list view
          Container(
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workoutType.length,
                  itemBuilder: (context, index) {
                    return WorkoutType(
                        workoutType: workoutType[index][0],
                        isSelected: workoutType[index][1],
                        onTapHead: () {
                          workoutTypeSelected(index);
                        });
                  })),

          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ImageTile(
                  workoutImgPath: 'assets/images/chest.jpg',
                  workoutName: 'Chest',
                ),
                ImageTile(
                  workoutImgPath: 'assets/images/abs.jpg',
                  workoutName: 'Abs',
                ),
                ImageTile(
                  workoutImgPath: 'assets/images/shoulder.png',
                  workoutName: 'Shoulder',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
