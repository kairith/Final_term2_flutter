import 'package:flutter_final/models/Sport_model.dart';

class Race {
  final DateTime startTime;
  final List<UserModel> runners;
  bool isStarted;
  bool isFinished;

  Race({
    required this.startTime,
    required this.runners,
    this.isStarted = false,
    this.isFinished = false,
  });

  void startRace() {
    isStarted = true;
  }

  void finishRace() {
    isFinished = true;
  }

  void recordLap(int bibNumber, DateTime finishTime) {
    final runner = runners.firstWhere((r) => r.bibNumber == bibNumber);
    runner.finishTime = finishTime.difference(startTime);
    _updateRanks();
  }

  void _updateRanks() {
    runners.sort((a, b) {
      if (a.finishTime == null) return 1;
      if (b.finishTime == null) return -1;
      return a.finishTime!.compareTo(b.finishTime!);
    });

    for (int i = 0; i < runners.length; i++) {
      if (runners[i].finishTime != null) {
        runners[i].rank = i + 1;
      }
    }
  }
}