class Player {
  final String id; // Ensure ID is present
  final String name;
  final String bibNumber;

  Player({required this.id, required this.name, required this.bibNumber});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bibNumber': bibNumber,
    };
  }

  Player copyWith({String? id, String? name, String? bibNumber}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      bibNumber: bibNumber ?? this.bibNumber,
    );
  }

  static Player fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      name: map['name'],
      bibNumber: map['bibNumber'],
    );
  }
}