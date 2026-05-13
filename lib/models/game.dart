import 'team.dart';

class Game {
  final Team home;
  final Team away;
  final String? status;

  Game({required this.home, required this.away, this.status});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      home: Team.fromJson((json['homeTeam'] as Map<String, dynamic>? ?? {})),
      away: Team.fromJson((json['awayTeam'] as Map<String, dynamic>? ?? {})),
      status: json['timeRemaining']?.toString(),
    );
  }
}
