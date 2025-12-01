import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/countries.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/teletext_text.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  late String _selectedCountry;

  @override
  void initState() {
    super.initState();
    final stored = context.read<AppState>().selectedCountry;
    _selectedCountry = stored ?? countries['Finland']!;
  }

  @override
  Widget build(BuildContext context) {
    final entries = countries.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const TeletextText(
            'Pick the country whose players you want highlighted',
            style: TextStyle(fontSize: 16, color: AppColors.blue),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<String>(
              value: _selectedCountry,
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
                  setState(() => _selectedCountry = value);
                }
              },
              items: entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.value,
                      child: TeletextText(
                        entry.key,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Teletext', fontSize: 16),
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final appState = context.read<AppState>();
              await appState.setCountry(_selectedCountry);
              if (!mounted) return;
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Country saved'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}
