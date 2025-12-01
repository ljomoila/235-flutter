import 'team.dart';

class Game {
  final Team home;
  final Team away;
  final String? timeRemaining;
  final dynamic period;

  Game({
    required this.home,
    required this.away,
    this.timeRemaining,
    this.period,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      home: Team.fromJson((json['home'] as Map<String, dynamic>? ?? {})),
      away: Team.fromJson((json['away'] as Map<String, dynamic>? ?? {})),
      timeRemaining: json['timeRemaining']?.toString(),
      period: json['period'],
    );
  }
}
