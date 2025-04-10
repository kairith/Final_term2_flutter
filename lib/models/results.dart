import 'package:flutter_final/models/Sport_model.dart';

class ResultSport {
  final int bibNumber;
  final String name;
  final Duration finishTime;
  final int rank;

  ResultSport({
    required this.bibNumber,
    required this.name,
    required this.finishTime,
    required this.rank,
  });

  factory ResultSport.fromUser(UserModel user) {
    return ResultSport(
      bibNumber: user.bibNumber,
      name: user.name,
      finishTime: user.finishTime ?? Duration.zero,
      rank: user.rank ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bibNumber': bibNumber,
      'name': name,
      'finishTime': finishTime.inMilliseconds,
      'rank': rank,
    };
  }

  factory ResultSport.fromMap(Map<String, dynamic> map) {
    return ResultSport(
      bibNumber: map['bibNumber'],
      name: map['name'],
      finishTime: Duration(milliseconds: map['finishTime']),
      rank: map['rank'],
    );
  }
}
