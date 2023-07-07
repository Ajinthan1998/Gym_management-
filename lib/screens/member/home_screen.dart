import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Home Page',
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
