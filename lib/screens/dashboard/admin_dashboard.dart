import 'package:flutter/material.dart';
import 'package:flutter_final/screens/edit_competition.dart';
import 'package:intl/intl.dart';
import 'package:flutter_final/models/competition.dart';

class AdminRaceOverviewScreen extends StatefulWidget {
  const AdminRaceOverviewScreen({super.key});

  @override
  _AdminRaceOverviewScreenState createState() => _AdminRaceOverviewScreenState();
}

class _AdminRaceOverviewScreenState extends State<AdminRaceOverviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample list of races (replace with actual data source in a real app)
  List<Competition> races = [
    Competition(
      name: "Spring Marathon",
      distance: "42km",
      date: "2025-04-20", // Stored as yyyy-MM-dd
      type: CompetitionType.running,
    ),
    Competition(
      name: "City Cycle Race",
      distance: "50km",
      date: "2025-05-15",
      type: CompetitionType.cycling,
    ),
    Competition(
      name: "Swim Challenge",
      distance: "2km",
      date: "2025-06-10",
      type: CompetitionType.swimming,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MM:dd:yy').format(parsedDate); // Format as mm:dd:yy
    } catch (_) {
      return date; // Fallback to raw string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700, // Fallback color
      appBar: AppBar(
        title: const Text(
          "Sport",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "sport"),
            Tab(text: "player"),
            Tab(text: "Timer"),
            Tab(text: "Dashboard"),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade200],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Sport Tab: List of races
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: races.map((race) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Icon based on competition type
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.blue.shade700, width: 2),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      race.type == CompetitionType.running
                                          ? Icons.directions_run
                                          : race.type == CompetitionType.cycling
                                              ? Icons.directions_bike
                                              : Icons.pool,
                                      size: 30,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Race details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Race name: ${race.name}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Distance: ${race.distance}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Date: ${_formatDate(race.date)}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit button
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue.shade700,
                                  ),
                                  onPressed: () async {
                                    final updatedRace = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCompetitionScreen(
                                          competition: race,
                                        ),
                                      ),
                                    );
                                    if (updatedRace != null) {
                                      setState(() {
                                        int index = races.indexOf(race);
                                        races[index] = updatedRace;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            // Player Tab: Placeholder
            Center(
              child: Text(
                "Player Tab",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Timer Tab: Placeholder
            Center(
              child: Text(
                "Timer Tab",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Dashboard Tab: Placeholder
            Center(
              child: Text(
                "Dashboard Tab",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}