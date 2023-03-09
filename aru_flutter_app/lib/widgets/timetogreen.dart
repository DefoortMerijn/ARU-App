import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';

class TimeToGreen extends StatefulWidget {
  @override
  State<TimeToGreen> createState() => _TimeToGreenState();
}

class _TimeToGreenState extends State<TimeToGreen> {
  int _counter = 5;
  @override
  void initState() {
    super.initState();
    _startTimer(); //call it over here
  }

  void _startTimer() async {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            if (_counter > 0) {
              _counter--;
            } else {
              timer.cancel();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (_counter > 0) ? Colors.grey[700] : Colors.green[700],
      appBar: AppBar(
        title: Text('Timer :hourglass_flowing_sand:'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_counter > 0)
                ? const AvatarGlow(
                    startDelay: Duration(microseconds: 0),
                    endRadius: 200.0,
                    animate: true,
                    duration: Duration(milliseconds: 1000),
                    repeatPauseDuration: Duration(milliseconds: 0),
                    child: Material(),
                  )
                : const AvatarGlow(
                    startDelay: Duration(microseconds: 0),
                    endRadius: 200.0,
                    animate: true,
                    repeat: true,
                    duration: Duration(microseconds: 500),
                    repeatPauseDuration: Duration(microseconds: 100),
                    child: Material(),
                  ),
            (_counter > 0)
                ? Text(
                    '$_counter',
                    style: const TextStyle(
                      fontSize: 128,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'GO',
                    style: TextStyle(
                      fontSize: 128,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
