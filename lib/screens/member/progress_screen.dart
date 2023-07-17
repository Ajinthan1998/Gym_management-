import 'package:flutter/material.dart';
import 'package:sample_app/screens/member/prog.dart';



class Progress extends StatelessWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? userId = Provider.of<UserProvider>(context).userId;
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              'Progress Page',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),

            ChartScreen(),

            // Text(userId!),
          ],
        ),
      ),
    );
  }
}
