
import 'dart:async';

import 'package:flutter/material.dart';

class TimerWithLap extends StatefulWidget {
  @override
  _TimerWithLapState createState() => _TimerWithLapState();
}

class _TimerWithLapState extends State<TimerWithLap> {
  late Timer _timer;
  Duration _duration = Duration();
  bool _isRunning = false;
  final List<String> _laps = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _duration += Duration(milliseconds: 10);
      });
    });
    _isRunning = true;
  }

  void _stopTimer() {
    _timer.cancel();
    _isRunning = false;
  }

  void _resetTimer() {
    if (_isRunning) _timer.cancel();
    setState(() {
      _duration = Duration();
      _laps.clear();
      _isRunning = false;
    });
  }

  void _addLap() {
    setState(() {
      _laps.add(_formatDuration(_duration));
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return "${twoDigits(d.inHours)}:"
           "${twoDigits(d.inMinutes.remainder(60))}:"
           "${twoDigits(d.inSeconds.remainder(60))}."
           "${threeDigits(d.inMilliseconds.remainder(1000))}";
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Race Timer"),
      backgroundColor: Colors.blue.shade700, // AppBar color
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              _formatDuration(_duration),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  child: Text(_isRunning ? "Pause" : "Start"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isRunning ? _addLap : null,
                  child: Text("Lap"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text("Reset"),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("Lap ${index + 1}", style: TextStyle(color: Colors.white)),
                    title: Text(_laps[index], style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}