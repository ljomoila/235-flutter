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
            title: player?.displayName() ?? 'Player',
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

  Widget _buildBody(AppState state) {
    if (state.loadingPlayer) {
      return const Center(child: Loading(message: 'Loading stats...'));
    }

    if (state.playerStatsError != null || state.playerStats == null) {
      return NotificationBanner(
        message: state.playerStatsError ?? 'Failed to load player stats',
      );
    }

    final entries = state.playerStats!.entries.toList();

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
                entry.key,
                style: const TextStyle(color: AppColors.blue),
              ),
            ),
            Expanded(
              flex: 1,
              child: TeletextText(
                entry.value.toString(),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      },
    );
  }
}
