import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/player_detail_screen.dart';
import 'screens/scores_screen.dart';
import 'screens/select_country_screen.dart';
import 'screens/settings_screen.dart';
import 'services/api_client.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'widgets/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TwoThreeFiveApp());
}

class TwoThreeFiveApp extends StatelessWidget {
  const TwoThreeFiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(apiClient: ApiClient())..initialize(),
        ),
      ],
      child: MaterialApp(
        title: '235',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => const MainTabs(),
          '/player': (_) => const PlayerDetailScreen(),
        },
      ),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          _HomeView(appState: appState),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: AppColors.background,
        elevation: 10,
        indicatorColor: AppColors.border.withValues(alpha: 0.6),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_hockey_outlined),
            selectedIcon: Icon(Icons.sports_hockey),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    if (appState.initializing) {
      return const Scaffold(
        body: Center(child: Loading(message: 'Preparing app...')),
      );
    }

    if (appState.selectedCountry == null) {
      return const Scaffold(body: SafeArea(child: SelectCountryScreen()));
    }

    return const ScoresScreen();
  }
}
