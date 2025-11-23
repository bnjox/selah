import 'package:flutter_test/flutter_test.dart';
import 'package:selah/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the Sessions page.
    expect(find.text('Sessions'), findsWidgets); // App bar and/or BottomNav
    expect(find.text('Topics'), findsOneWidget); // BottomNav
    expect(find.text('Settings'), findsOneWidget); // BottomNav
  });
}
