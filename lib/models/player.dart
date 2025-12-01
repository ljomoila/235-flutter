class Player {
  final int? id;
  final int? playerId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? nationality;
  final String? position;
  final int? goals;
  final int? assists;
  final int? points;
  final String? saveShotsAgainst;
  final double? savePercentage;

  const Player({
    this.id,
    this.playerId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.nationality,
    this.position,
    this.goals,
    this.assists,
    this.points,
    this.saveShotsAgainst,
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
      playerId: parseInt(json['playerId']),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      nationality: json['nationality'] as String?,
      position: json['position'] as String?,
      goals: parseInt(json['goals']),
      assists: parseInt(json['assists']),
      points: parseInt(json['points']),
      saveShotsAgainst: json['saveShotsAgainst']?.toString(),
      savePercentage: parseDouble(json['savePercentage']),
    );
  }

  String displayName() => lastName ?? fullName ?? firstName ?? 'Unknown';
}
