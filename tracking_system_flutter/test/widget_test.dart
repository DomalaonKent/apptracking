import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_system/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TrackingSystemApp());
    expect(find.byType(TrackingSystemApp), findsOneWidget);
  });
}