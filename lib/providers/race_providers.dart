import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_final/models/Sport_model.dart';
import 'package:flutter_final/models/race_model.dart';
import 'package:flutter_final/models/results.dart';

class RaceProvider with ChangeNotifier {
  Race? _race;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  Race get race => _race!;

  Duration get elapsedTime => _elapsedTime;

  // Start the race and initialize the timer
  void startRace(DateTime startTime, List<UserModel> runners) {
    _race = Race(startTime: startTime, runners: runners);
    _startTimer();
    notifyListeners();
  }

  // Stop the race and the timer
  void finishRace() {
    _race!.finishRace();
    _timer?.cancel();
    notifyListeners();
  }

  // Record a lap (update the time when a runner reaches the finish line)
  void recordRace(int bibNumber, DateTime finishTime) {
    _race!.recordLap(bibNumber, finishTime);
    notifyListeners();
  }

  // Get the race results
  List<ResultSport> get raceResults {
    return _race?.runners
            .map((user) => ResultSport.fromUser(user))
            .toList() ??
        [];
  }

  // Start a timer to track the elapsed time during the race
  void _startTimer() {
    _elapsedTime = Duration.zero;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime = Duration(seconds: timer.tick);
      notifyListeners(); // Update every second
    });
  }

  // Reset the race and timer (if needed)
  void resetRace() {
    _race = null;
    _elapsedTime = Duration.zero;
    _timer?.cancel();
    notifyListeners();
  }
}
