import 'package:flutter_test/flutter_test.dart';

import 'package:sentry_mobile/main.dart';

void main() {
  testWidgets('release page opens', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Main page body:'), findsOneWidget);
  });
}
