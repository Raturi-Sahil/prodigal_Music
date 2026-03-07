import 'package:flutter_test/flutter_test.dart';
import 'package:music_app_frontend/main.dart';

void main() {
  testWidgets('MusicApp renders HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MusicApp());
    expect(find.text('Music App'), findsOneWidget);
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
