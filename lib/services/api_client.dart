import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/game.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _defaultBaseUrl = 'http://localhost:5069';
  static const String _apiKeyHeader = 'X-API-Key';

  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String _apiKeyValue = String.fromEnvironment(
    'API_KEY_VALUE',
    defaultValue: 'changeme',
  );

  Future<List<Game>> fetchGames(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data = await _get('/games/$formattedDate');

    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Game.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Unexpected games payload');
  }

  Future<Map<String, dynamic>> fetchPlayerStats(
    int playerId, {
    String statsType = 'yearByYear',
  }) async {
    final data = await _get('/players/$playerId/stats/$statsType');

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception('Unexpected player stats payload');
  }

  Future<dynamic> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(
      uri,
      headers: {_apiKeyHeader: _apiKeyValue},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed (${response.statusCode})');
    }

    final parsed = jsonDecode(response.body);

    if (parsed is Map && parsed['error'] == true) {
      throw Exception(parsed['message']?.toString() ?? 'API error');
    }

    return parsed;
  }

  void dispose() {
    _client.close();
  }
}
