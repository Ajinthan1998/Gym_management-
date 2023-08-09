import 'package:flutter/material.dart';

class CoachCheckProg extends StatefulWidget {
  const CoachCheckProg({Key? key}) : super(key: key);

  @override
  State<CoachCheckProg> createState() => _CoachCheckProgState();
}

class _CoachCheckProgState extends State<CoachCheckProg> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Coach check progress',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
