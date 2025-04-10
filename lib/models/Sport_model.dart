class UserModel {
  final String name;
  final int bibNumber;
  int? rank;
  Duration? finishTime;

  UserModel({
    required this.name,
    required this.bibNumber,
    this.rank,
    this.finishTime,
  });
}