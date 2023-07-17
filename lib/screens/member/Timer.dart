import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:audioplayers/audio_cache.dart';


class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  // final AudioCache audioCache = AudioCache();

  int _seconds = maxSeconds;
  bool _isActive = false;
  late Timer _timer;
  static int get maxSeconds => 5;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
           _timer.cancel();
          print('Timer reached zero!');
        }
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      _seconds = maxSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_seconds seconds',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text(_isActive ? 'Stop' : 'Start'),
                  onPressed: () {
                    setState(() {
                      _isActive = !_isActive;
                      if (_isActive) {
                        startTimer();
                      } else {
                        stopTimer();
                      }
                    });
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setState(() {
                      resetTimer();
                    });
                  },
                ),
              ],
            ),
            // ElevatedButton(
            //   child: Text('Audio'),
            //   onPressed: () {
            //     audioCache.play('assets/audios/attention.mp3');
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimerPage(),
  ));
}
