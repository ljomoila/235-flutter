import 'team.dart';

class Game {
  final Team home;
  final Team away;
  final String? status;

  Game({required this.home, required this.away, this.status});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      home: Team.fromJson((json['home'] as Map<String, dynamic>? ?? {})),
      away: Team.fromJson((json['away'] as Map<String, dynamic>? ?? {})),
      status: json['status']?.toString(),
    );
  }
}
