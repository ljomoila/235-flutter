import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../theme.dart';
import 'teletext_text.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.game,
    required this.onPlayerTap,
    this.selectedCountry,
  });

  final Game game;
  final void Function(Player player) onPlayerTap;
  final String? selectedCountry;

  TextStyle _playerStyle(Player player) {
    final bool isHighlighted =
        selectedCountry != null && player.nationality == selectedCountry;

    return TextStyle(
      color: isHighlighted ? AppColors.green : AppColors.blue,
      fontSize: 13,
    );
  }

  bool _isGoalie(Player player) {
    return player.position?.toLowerCase() == 'goalie';
  }

  Widget _buildPlayer(Player player, {required TextAlign align}) {
    final name = player.lastName ?? 'FIXME';
    final truncatedName = name.length > 14 ? name.substring(0, 14) : name;

    final stats = _isGoalie(player)
        ? '${player.saveShotsAgainst ?? '0/0'} ${player.savePercentage?.toStringAsFixed(1) ?? '0'}%'
        : '${player.goals ?? 0}+${player.assists ?? 0}';

    final wrapAlignment = align == TextAlign.left
        ? WrapAlignment.start
        : WrapAlignment.end;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onPlayerTap(player),
        child: Wrap(
          alignment: wrapAlignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 2,
          children: [
            TeletextText(
              truncatedName,
              style: _playerStyle(player),
              textAlign: align,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            TeletextText(
              stats,
              style: _playerStyle(player),
              textAlign: align,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeam(Team team, {required bool isHome}) {
    final TextAlign align = isHome ? TextAlign.left : TextAlign.right;
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: isHome
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          TeletextText(
            team.shortName ?? team.name,
            style: const TextStyle(fontSize: 16, color: AppColors.white),
            textAlign: align,
          ),
          const SizedBox(height: 6),
          ...team.players.map((p) => _buildPlayer(p, align: align)),
        ],
      ),
    );
  }

  Widget _buildScore() {
    final int homeGoals = game.home.goals ?? 0;
    final int awayGoals = game.away.goals ?? 0;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TeletextText(
            '$homeGoals-$awayGoals',
            style: const TextStyle(color: AppColors.green, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (game.status != null)
            TeletextText(
              game.status!,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeam(game.home, isHome: true),
          _buildScore(),
          _buildTeam(game.away, isHome: false),
        ],
      ),
    );
  }
}
