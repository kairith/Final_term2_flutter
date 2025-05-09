import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_final/models/player.dart';
import 'package:http/http.dart' as http;

class TimerWithLap extends StatefulWidget {
  final VoidCallback onRaceSaved;
  const TimerWithLap({Key? key, required this.onRaceSaved}) : super(key: key);
  @override
  _TimerWithLapState createState() => _TimerWithLapState();
}

class _TimerWithLapState extends State<TimerWithLap> {
  late Timer _timer;
  Duration _duration = const Duration();
  bool _isRunning = false;
  final List<Duration> _unassignedLaps = [];
  final Map<Duration, String?> _lapAssignments = {};
  List<Player> _players = [];
  Set<String> _assignedBibs = {}; // Track assigned bib numbers

  static const String baseUrl = 'https://sporttrackingapp-default-rtdb.asia-southeast1.firebasedatabase.app';

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final uri = Uri.parse('$baseUrl/players.json');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _players = data.entries.map((entry) {
            return Player.fromMap(entry.key, entry.value);
          }).toList();
        });
      } else {
        print('Failed to fetch players: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to fetch players: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching players: $e');
      throw Exception('Error fetching players: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _duration += const Duration(milliseconds: 10);
      });
    });
    _isRunning = true;
  }

  void _stopTimer() {
    _timer.cancel();
    _isRunning = false;
  }

  void _resetTimer() {
    if (_isRunning) _timer.cancel();
    setState(() {
      _duration = const Duration();
      _unassignedLaps.clear();
      _lapAssignments.clear();
      _isRunning = false;
    });
  }

  void _addLap() {
    setState(() {
      _unassignedLaps.add(_duration);
      _lapAssignments[_duration] = null;
    });
  }

  Future<void> _assignBib(Duration lapTime) async {
    String? selectedBib;

    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Assign Bib Number"),
          content: DropdownButtonFormField<String>(
            hint: const Text("Select a player"),
            value: selectedBib,
            items: _players
                .where((player) => !_assignedBibs.contains(player.bibNumber)) // Filter out already assigned bibs
                .map((player) {
              return DropdownMenuItem<String>(
                value: player.bibNumber,
                child: Text(player.bibNumber),
              );
            }).toList(),
            onChanged: (value) {
              selectedBib = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedBib);
              },
              child: const Text("Assign"),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _lapAssignments[lapTime] = value;
          _assignedBibs.add(value);
        });
      }
    });
  }

  Future<void> _saveRace() async {
    //Clear assigned bibs before saving
    _assignedBibs.clear();

    final Map<String, List<Duration>> playerLaps = {};

    for (var entry in _lapAssignments.entries) {
      if (entry.value != null) {
        playerLaps.putIfAbsent(entry.value!, () => []);
        playerLaps[entry.value!]!.add(entry.key);
        _assignedBibs.add(entry.value!); // Track assigned bibs
      }
    }

    for (var bib in playerLaps.keys) {
      try {
        final player = _players.firstWhere((player) => player.bibNumber == bib);
        for (var lapTime in playerLaps[bib]!) {
          await _updatePlayerFinishTime(player, lapTime);
        }
      } catch (e) {
        print('Error finding or updating player: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving race.  Could not find player with bib number $bib")),
        );
        return;
      }
    }

    widget.onRaceSaved();
    await _fetchPlayers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Race saved successfully!")),
    );
  }

  Future<void> _updatePlayerFinishTime(Player player, Duration finishTime) async {
    final updatedPlayer = player.copyWith(finishTime: finishTime);
    final uri = Uri.parse('$baseUrl/players/${player.id}.json');
    try {
      final response = await http.put(
        uri,
        body: json.encode(updatedPlayer.toMap()),
      );
      if (response.statusCode != 200) {
        print('Failed to update player: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to update player');
      }
    } catch (e) {
      print('Error updating player: $e');
      throw Exception('Error updating player: $e');
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}.${threeDigits(d.inMilliseconds.remainder(1000))}";
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                _formatDuration(_duration),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isRunning ? _stopTimer : _startTimer,
                    child: Text(_isRunning ? "Pause" : "Start"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isRunning ? _addLap : null,
                    child: const Text("Lap"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _resetTimer,
                    child: const Text("Reset"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _lapAssignments.isNotEmpty ? _saveRace : null,
                    child: const Text("Save"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: _unassignedLaps.length,
                  itemBuilder: (context, index) {
                    final lapTime = _unassignedLaps[index];
                    final bib = _lapAssignments[lapTime];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Text(
                          "Lap ${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          _formatDuration(lapTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        trailing: bib == null
                            ? IconButton(
                                icon: const Icon(Icons.person_add, color: Colors.white),
                                onPressed: () => _assignBib(lapTime),
                              )
                            : Text(
                                "Bib: $bib",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}