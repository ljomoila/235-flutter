import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:two_three_five/main.dart';

void main() {
  testWidgets('shows country selector when no country is stored', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const TwoThreeFiveApp());
    await tester.pumpAndSettle();

    expect(find.text('Select'), findsWidgets);
  });
}
