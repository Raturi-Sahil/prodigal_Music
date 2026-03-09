import 'package:flutter_test/flutter_test.dart';
import 'package:music_app_frontend/main.dart';

void main() {
  testWidgets('DhanurAIApp renders SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const DhanurAIApp());

    // Pump the animation frames so the fade-in completes
    await tester.pump(const Duration(milliseconds: 1600));

    expect(find.text('Dhanur AI'), findsOneWidget);
    expect(find.text('Music powered by AI'), findsOneWidget);

    // Pump past the splash timer so no pending timers remain
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
