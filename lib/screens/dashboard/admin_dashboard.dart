import 'package:flutter/material.dart';
import 'package:flutter_final/models/competition.dart';
import 'package:flutter_final/models/player.dart';
import 'package:flutter_final/repositories/race_repository.dart';
import 'package:flutter_final/screens/dashboard/players/edit_player_screen.dart';
import 'package:flutter_final/screens/dashboard/players/create_player_screen.dart';
import 'package:flutter_final/screens/dashboard/sports/edit_competition.dart';
import 'package:intl/intl.dart';
import 'package:flutter_final/screens/dashboard/times/timer_screen.dart';

class AdminRaceOverviewScreen extends StatefulWidget {
  const AdminRaceOverviewScreen({super.key});

  @override
  State<AdminRaceOverviewScreen> createState() => _AdminRaceOverviewScreenState();
}

class _AdminRaceOverviewScreenState extends State<AdminRaceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseRaceRepository _repository = FirebaseRaceRepository();
  bool _isLoading = false;

  List<Competition> races = [
    Competition(
      name: "Spring Marathon",
      distance: "42km",
      date: "2025-04-20",
      type: CompetitionType.running,
    ),
  ];

  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchPlayers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlayers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Player> fetchedPlayers = await _repository.getPlayers();
      setState(() {
        players = fetchedPlayers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching players: $e')),
      );
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MM-dd-yy').format(parsedDate);
    } catch (_) {
      return date;
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "N/A";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}.${threeDigits(duration.inMilliseconds.remainder(1000))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        title: const Text(
          "Sport",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
            Tab(text: "Sport"),
            Tab(text: "Player"),
            Tab(text: "Timer"),
            Tab(text: "Results"),
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
            _buildSportTab(),
            _buildPlayerTab(),
            Center(child: TimerWithLap(onRaceSaved: _fetchPlayers)),
            _buildResultsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSportTab() {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: races.map((race) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade700,
                            width: 2,
                          ),
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
                      title: Text(
                        "Race name: ${race.name}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Distance: ${race.distance}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${_formatDate(race.date)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
      ],
    );
  }

  Widget _buildPlayerTab() {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: List.generate(players.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        players[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        "Bib Number: ${players[index].bibNumber}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final updatedPlayer = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPlayerScreen(
                                      player: players[index],
                                    ),
                                  ),
                                );
                                if (updatedPlayer != null) {
                                  setState(() {
                                    players[index] = updatedPlayer;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Player"),
                                      content: const Text(
                                        "Are you sure you want to delete this player?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            try {
                                              await _repository.deletePlayer(
                                                players[index].id,
                                              );
                                              setState(() {
                                                players.removeAt(index);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Player deleted successfully'),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed to delete player: $e'),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 30,
          child: FloatingActionButton(
            onPressed: () async {
              final newPlayer = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePlayerScreen()),
              );
              if (newPlayer != null) {
                setState(() {
                  players.add(newPlayer);
                });
              }
            },
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTab() {
    // Sort players by finish time (nulls last)
    final sortedPlayers = players.toList()
      ..sort((a, b) {
        if (a.finishTime == null && b.finishTime == null) return 0;
        if (a.finishTime == null) return 1;
        if (b.finishTime == null) return -1;
        return a.finishTime!.compareTo(b.finishTime!);
      });

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.white)),
                if (!_isLoading && sortedPlayers.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Congratulations",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!_isLoading && sortedPlayers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "No players have finished yet.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ...sortedPlayers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          player.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          "Bib Number: ${player.bibNumber}\nFinish Time: ${_formatDuration(player.finishTime)}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            right: 30,
            child: FloatingActionButton(
              onPressed: _fetchPlayers,
              backgroundColor: Colors.white,
              child: const Icon(Icons.refresh, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}