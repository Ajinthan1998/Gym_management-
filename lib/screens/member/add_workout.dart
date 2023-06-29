import 'package:flutter/material.dart';

class AddWorkout extends StatelessWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Add Own workouts',
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
