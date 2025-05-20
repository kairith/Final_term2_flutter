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

  void startRace(DateTime startTime, List<UserModel> runners) {
    _race = Race(startTime: startTime, runners: runners);
    _startTimer();
    notifyListeners();
  }
  void finishRace() {
    _race!.finishRace();
    _timer?.cancel();
    notifyListeners();
  }
  void recordRace(int bibNumber, DateTime finishTime) {
    _race!.recordLap(bibNumber, finishTime);
    notifyListeners();
  }

  List<ResultSport> get raceResults {
    return _race?.runners
            .map((user) => ResultSport.fromUser(user))
            .toList() ??
        [];
  }
  void _startTimer() {
    _elapsedTime = Duration.zero;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime = Duration(seconds: timer.tick);
      notifyListeners(); // Update every second
    });
  }
  void resetRace() {
    _race = null;
    _elapsedTime = Duration.zero;
    _timer?.cancel();
    notifyListeners();
  }
}
