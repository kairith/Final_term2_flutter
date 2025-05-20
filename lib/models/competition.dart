enum CompetitionType {
  running('Running'),
  cycling('Cycling'),
  swimming('Swimming');
  final String displayName;
  const CompetitionType(this.displayName);
}
class Competition {
  final String name;
  final String distance;
  final String date; 
  final CompetitionType type;

  Competition({
    required this.name,
    required this.distance,
    required this.date,
    required this.type,
  });
}