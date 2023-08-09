import 'package:flutter/material.dart';

class CoachAddWorkout extends StatefulWidget {
  const CoachAddWorkout({Key? key}) : super(key: key);

  @override
  State<CoachAddWorkout> createState() => _CoachAddWorkoutState();
}

class _CoachAddWorkoutState extends State<CoachAddWorkout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Home Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}