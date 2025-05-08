import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_final/models/player.dart';
import 'package:http/http.dart' as http;

class TimerWithLap extends StatefulWidget {
  final VoidCallback onRaceSaved; // Callback to notify when race is saved

  TimerWithLap({required this.onRaceSaved}); // Constructor

  @override
  _TimerWithLapState createState() => _TimerWithLapState();
}

class _TimerWithLapState extends State<TimerWithLap> {
  late Timer _timer;
  Duration _duration = Duration();
  bool _isRunning = false;
  final List<Map<String, String>> _laps = [];
  List<Player> _players = [];
  String? _selectedBib;

  // To keep track of lap times for each player
  Map<String, List<Duration>> playerLapTimes = {};

  static const String baseUrl = 'https://sporttrackingapp-default-rtdb.asia-southeast1.firebasedatabase.app';

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final uri = Uri.parse('$baseUrl/players.json');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _players = data.entries.map((entry) {
          return Player.fromMap(entry.key, entry.value);
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch players: ${response.body}');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _duration += Duration(milliseconds: 10);
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
      _duration = Duration();
      _laps.clear();
      playerLapTimes.clear(); // Reset player lap times
      _isRunning = false;
    });
  }

  void _addLap(String selectedBib) {
    setState(() {
      _laps.add({
        'time': _formatDuration(_duration),
        'bib': selectedBib,
      });

      // Add the lap time to the player's lap times
      playerLapTimes[selectedBib] ??= [];
      playerLapTimes[selectedBib]!.add(_duration); // Store the lap time

      _selectedBib = null; // Reset selection after adding lap
    });
  }

  Future<void> _saveRace() async {
  for (var bib in playerLapTimes.keys) {
    final player = _players.firstWhere((player) => player.bibNumber == bib);
    
    // Save each player's finish time based on their individual laps
    for (var lapTime in playerLapTimes[bib]!) {
      await _updatePlayerFinishTime(player, lapTime);
    }
  }

  // Call the callback to notify that the race has been saved
  widget.onRaceSaved();
  // Refresh player data
  await _fetchPlayers();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Race saved successfully!")),
  );
}

  Future<void> _updatePlayerFinishTime(Player player, Duration finishTime) async {
    final updatedPlayer = player.copyWith(finishTime: finishTime);
    final uri = Uri.parse('$baseUrl/players/${player.id}.json');

    await http.put(uri, body: json.encode(updatedPlayer.toMap()));
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

  void _showLapDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Bib Number"),
          content: DropdownButtonFormField<String>(
            hint: Text("Select a player"),
            value: _selectedBib,
            items: _getAvailableBibs().map((player) {
              return DropdownMenuItem<String>(
                value: player.bibNumber,
                child: Text(player.bibNumber),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBib = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_selectedBib != null) {
                  _addLap(_selectedBib!);
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text("Add Lap"),
            ),
          ],
        );
      },
    );
  }

  List<Player> _getAvailableBibs() {
    final selectedBibs = _laps.map((lap) => lap['bib']).toSet();
    return _players.where((player) => !selectedBibs.contains(player.bibNumber)).toList();
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
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
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
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isRunning ? _showLapDialog : null,
                    child: Text("Lap"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _resetTimer,
                    child: Text("Reset"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _saveRace,
                    child: Text("Save"),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: _laps.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Text(
                          "Lap ${index + 1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          "${_laps[index]['time']} - Bib: ${_laps[index]['bib']}",
                          style: TextStyle(
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