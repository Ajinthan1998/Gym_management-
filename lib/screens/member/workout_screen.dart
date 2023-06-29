import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'workout Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Image(
            image: AssetImage("assets/images/jk fitness.jpg"),
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
