import 'package:flutter_test/flutter_test.dart';
import 'package:music_app_frontend/main.dart';

void main() {
  testWidgets('MyApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}
