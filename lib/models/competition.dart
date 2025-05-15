enum CompetitionType {
  running('Running'),
  cycling('Cycling'),
  swimming('Swimming');
  final String displayName;
  const CompetitionType(this.displayName);
}

class Competition {
  
  final String name; // Name of the competition
  final String distance; // Distance of the competition (e.g., "5km")
  final String date; // Date of the competition (e.g., "2025-04-20")
  final CompetitionType type; // Type of competition (running, cycling, swimming)

  Competition({
    
    required this.name,
    required this.distance,
    required this.date,
    required this.type,
  });
}