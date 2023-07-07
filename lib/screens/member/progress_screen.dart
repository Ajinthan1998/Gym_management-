import 'package:flutter/material.dart';

import 'SecondRoute.dart';

class Progress extends StatelessWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? userId = Provider.of<UserProvider>(context).userId;
    return Center(
      child: Column(
        children: [
          Text(
            'Progress Page',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProgressChart()));
              },
              child: Text("To MBI"))
          // Text(userId!),
        ],
      ),
    );
  }
}
