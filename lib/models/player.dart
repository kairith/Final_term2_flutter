class Player {
  final String id;
  final String name;
  final String bibNumber;
  final Duration? finishTime;

  Player({
    required this.id,
    required this.name,
    required this.bibNumber,
    this.finishTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bibNumber': bibNumber,
      'finishTime': finishTime?.inMilliseconds,
    };
  }
  Player copyWith({
    String? id,
    String? name,
    String? bibNumber,
    Duration? finishTime,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      bibNumber: bibNumber ?? this.bibNumber,
      finishTime: finishTime ?? this.finishTime,
    );
  }

  static Player fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      name: map['name'],
      bibNumber: map['bibNumber'],
      finishTime: map['finishTime'] != null
          ? Duration(milliseconds: map['finishTime'])
          : null,
    );
  }
}