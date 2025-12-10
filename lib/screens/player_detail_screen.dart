import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/loading.dart';
import '../widgets/notification_banner.dart';
import '../widgets/teletext_text.dart';
import '../widgets/top_bar.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final player = state.activePlayer;

        return Scaffold(
          appBar: TopBar(
            title: player?.fullName ?? 'FIXME',
            onBack: () {
              state.clearPlayer();
              Navigator.of(context).pop();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildBody(state),
          ),
        );
      },
    );
  }

  String getLabel(String key) {
    switch (key) {
      case 'gamesPlayed':
        return 'Games Played';
      case 'points':
        return 'Points';
      case 'assists':
        return 'Assists';
      case 'goals':
        return 'Goals';
      case 'pim':
        return 'Penalty Minutes';
      case 'avgToi':
        return 'Average Time on Ice';
      case 'plusMinus':
        return 'Plus/Minus';
      case 'shots':
        return 'Shots';
      case 'shotsOnGoal':
        return 'Shots on Goal';
      case 'powerPlayGoals':
        return 'Power Play Goals';
      case 'powerPlayPoints':
        return 'Power Play Points';
      case 'shortHandedGoals':
        return 'Short Handed Goals';
      case 'shortHandedPoints':
        return 'Short Handed Points';
      case 'shootingPctg':
        return 'Shooting Percentage';
      case 'faceoffWinningPctg':
        return 'Face Off Winning Perc';

      // Goalie stats
      case 'gamesStarted':
        return 'Games Started';
      case 'shotsAgainst':
        return 'Shots Against';
      case 'savePercentage':
        return 'Save Percentage';
      case 'goalsAgainstAverage':
        return 'Goals Against Average';
      case 'wins':
        return 'Wins';
      case 'losses':
        return 'Losses';
      case 'shutouts':
        return 'Shutouts';
      case 'otLosses':
        return 'Overtime Losses';
      case 'goalsAgainst':
        return 'Goals Against';
      default:
        return key;
    }
  }

  Widget _buildBody(AppState state) {
    if (state.loadingPlayer) {
      return const Center(child: Loading(message: 'Loading stats...'));
    }

    if (state.playerStats == null) {
      return const SizedBox.shrink();
    }

    if (state.playerStatsError != null) {
      return NotificationBanner(
        message: state.playerStatsError ?? 'Failed to load player stats',
      );
    }

    final entries = state.playerStats!.entries
        .map((entry) {
          // Filter out null values
          if (entry.value == null) {
            return null;
          }
          return MapEntry(entry.key, entry.value);
        })
        .whereType<MapEntry<String, dynamic>>()
        .toList();

    if (entries.isEmpty) {
      return const NotificationBanner(
        message: 'No stats found for player',
        type: NoticeType.info,
      );
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (context, _) => const Divider(color: AppColors.border),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: TeletextText(
                getLabel(entry.key),
                style: const TextStyle(color: AppColors.blue),
              ),
            ),
            Expanded(
              flex: 1,
              child: TeletextText(
                entry.value.toString(),
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.purple),
              ),
            ),
          ],
        );
      },
    );
  }
}
