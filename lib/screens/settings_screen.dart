import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/countries.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/top_bar.dart';
import '../widgets/teletext_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _country;

  @override
  void initState() {
    super.initState();
    _country =
        context.read<AppState>().selectedCountry ?? countries['Finland']!;
  }

  @override
  Widget build(BuildContext context) {
    final entries = countries.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: const TopBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TeletextText(
              'Highlight players from',
              style: TextStyle(
                color: AppColors.blue.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButton<String>(
                value: _country,
                iconEnabledColor: AppColors.white,
                dropdownColor: AppColors.background,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                style: const TextStyle(
                  fontFamily: 'Teletext',
                  color: AppColors.white,
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _country = value);
                  }
                },
                items: entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.value,
                        child: TeletextText(entry.key),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(
                  fontFamily: 'Teletext',
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                await appState.setCountry(_country);
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
