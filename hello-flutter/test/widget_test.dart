// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:benwo/app.dart';

void main() {
  testWidgets('BenWo app builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: BenWoApp(),
      ),
    );

    // Verify that the app builds without throwing
    expect(tester.takeException(), isNull);
  });
}
