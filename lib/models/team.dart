import 'player.dart';

class Team {
  final int? id;
  final String name;
  final int? score;
  final List<Player> players;

  Team({this.id, required this.name, this.score, List<Player>? players})
    : players = players ?? [];

  factory Team.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    final rawPlayers = json['players'] as List<dynamic>? ?? [];
    return Team(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? 'Unknown team',
      score: parseInt(json['score']),
      players: rawPlayers
          .whereType<Map<String, dynamic>>()
          .map(Player.fromJson)
          .toList(),
    );
  }
}
