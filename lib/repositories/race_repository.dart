import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_final/models/player.dart';

class FirebaseRaceRepository {
  static const String baseUrl = 'https://sporttrackingapp-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String competitionsCollection = 'competitions';
  static const String allCompetitionsUrl = '$baseUrl/$competitionsCollection.json';

  // Get all competitions
  Future<List<Map<String, dynamic>>> getCompetitions() async {
    final uri = Uri.parse(allCompetitionsUrl);
    final response = await http.get(uri);
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to fetch competitions: ${response.body}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    return data.entries.map((entry) => entry.value as Map<String, dynamic>).toList();
  }

  // Get all players
Future<List<Player>> getPlayers() async {
  final uri = Uri.parse('$baseUrl/players.json');
  final response = await http.get(uri);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to fetch players: ${response.body}');
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  return data.entries.map((entry) {
    return Player.fromMap(entry.key, entry.value); // Use entry.key for ID
  }).toList();
}

  // Add a new player
 Future<String> addPlayer(Player player) async {
  final uri = Uri.parse('$baseUrl/players.json');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(player.toMap()),
  );

  if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.created) {
    throw Exception('Failed to add player: ${response.body}');
  }

  // Return the ID of the newly created player
  final data = json.decode(response.body);
  return data['name']; // Firebase generates a unique key as the ID
}

  Future<void> updatePlayer(String playerId, Player player) async {
  final uri = Uri.parse('https://sporttrackingapp-default-rtdb.asia-southeast1.firebasedatabase.app/players/$playerId.json');
  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(player.toMap()), // Use the toMap method
  );

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to update player: ${response.body}');
  }
}
Future<void> deletePlayer(String playerId) async {
  final uri = Uri.parse('https://sporttrackingapp-default-rtdb.asia-southeast1.firebasedatabase.app/players/$playerId.json');
  final response = await http.delete(uri);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to delete player: ${response.body}');
  }
}
}