import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_final/models/competition.dart';
import 'package:flutter_final/models/player.dart';

import 'package:flutter_final/screens/dashboard/sports/edit_competition.dart';
import 'package:flutter_final/screens/dashboard/times/timer_screen.dart';
import 'package:flutter_final/screens/dashboard/players/edit_player_screen.dart';
import 'package:flutter_final/screens/dashboard/players/create_player_screen.dart';
import 'package:flutter_final/screens/dashboard/sports/create_competition.dart';

class AdminRaceOverviewScreen extends StatefulWidget {
  const AdminRaceOverviewScreen({super.key});

  @override
  State<AdminRaceOverviewScreen> createState() =>
      _AdminRaceOverviewScreenState();
}

class _AdminRaceOverviewScreenState extends State<AdminRaceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Competition> races = [
    Competition(
      name: "Spring Marathon",
      distance: "42km",
      date: "2025-04-20",
      type: CompetitionType.running,
    ),
  ];

  List<Player> players = [
    Player(bibNumber: "001", name: "vine"),
    Player(bibNumber: "002", name: "ronan"),
    Player(bibNumber: "003", name: "Mike"),
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
      return DateFormat('MM-dd-yy').format(parsedDate);
    } catch (_) {
      return date;
    }
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
            // Sport Tab
            Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children:
                          races.map((race) {
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
                                            : race.type ==
                                                CompetitionType.cycling
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          final updatedRace =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          EditCompetitionScreen(
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
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            races.remove(race);
                                          });
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
                // FAB to add race
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final newRace = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateCompetitionScreen(),
                        ),
                      );
                      if (newRace != null) {
                        setState(() {
                          races.add(newRace);
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),

            // Player Tab
            Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(players.length, (index) {
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
                              title: Text(
                                "Name: ${players[index].name}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              subtitle: Text(
                                "Number: ${players[index].bibNumber}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final updatedPlayer =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => EditPlayerScreen(
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        players.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // FAB to add player
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final newPlayer = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePlayerScreen(),
                        ),
                      );
                      if (newPlayer != null) {
                        setState(() {
                          players.add(newPlayer);
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),

            // Timer Tab
            Center(child: TimerWithLap()),

            // Dashboard Tab
            const Center(
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