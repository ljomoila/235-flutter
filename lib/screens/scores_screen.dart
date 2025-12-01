import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/date_selector.dart';
import '../widgets/loading.dart';
import '../widgets/notification_banner.dart';
import '../widgets/score_card.dart';
import '../widgets/teletext_text.dart';
import '../widgets/top_bar.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  bool _isPullToRefresh = false;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    if (appState.games.isEmpty && !appState.loadingScores) {
      appState.loadScores(skipIfUnselected: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: const TopBar(title: '235'),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: DateSelector(
                        date: state.selectedDate,
                        onPrevious: () => state.adjustDate(-1),
                        onNext: () => state.adjustDate(1),
                        onPick: state.changeDate,
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: AppColors.blue,
                        onRefresh: () async {
                          setState(() => _isPullToRefresh = true);
                          await state.refreshScores();
                          if (mounted) setState(() => _isPullToRefresh = false);
                        },
                        child: _buildBody(state),
                      ),
                    ),
                  ],
                ),
                if (state.loadingScores && !_isPullToRefresh)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: Loading(message: 'Loading scores...'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(AppState state) {
    if (state.loadingScores && state.games.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [],
      );
    }

    if (state.errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          NotificationBanner(message: 'Failed to load scores'),
          const SizedBox(height: 12),
          TeletextText(
            state.errorMessage!,
            style: TextStyle(color: Colors.red.withValues(alpha: 0.7)),
          ),
        ],
      );
    }

    if (state.games.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: TeletextText(
                'No scheduled games',
                style: TextStyle(color: AppColors.blue, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.games.length,
      itemBuilder: (context, index) {
        final Game game = state.games[index];
        return ScoreCard(
          game: game,
          selectedCountry: state.selectedCountry,
          onPlayerTap: (player) {
            // TODO: Implement player stats view
            // state.openPlayer(player);
            // Navigator.of(context).pushNamed('/player');
          },
        );
      },
    );
  }
}
