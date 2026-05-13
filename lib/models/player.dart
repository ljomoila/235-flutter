class Player {
  final int? id;
  final String? name;
  final String? nationality;
  final String? position;
  final int? goals;
  final int? assists;
  final int? saves;
  final int? shotsAgainst;
  final int? goalsAgainst;
  final double? savePercentage;

  const Player({
    this.id,
    this.name,
    this.nationality,
    this.position,
    this.goals,
    this.assists,
    this.saves,
    this.shotsAgainst,
    this.goalsAgainst,
    this.savePercentage,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    return Player(
      id: parseInt(json['id']),
      name: json['name'],
      nationality: json['country'] as String?,
      position: json['position'] as String?,
      goals: parseInt(json['goals']),
      assists: parseInt(json['assists']),
      saves: parseInt(json['saves']),
      shotsAgainst: parseInt(json['shotsAgainst']),
      goalsAgainst: parseInt(json['goalsAgainst']),
      savePercentage: parseDouble(json['savePercentage']),
    );
  }
}
