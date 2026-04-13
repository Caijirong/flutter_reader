import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/app/app.dart';

void main() {
  testWidgets('app shell exposes the navigation tabs', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.widgetWithText(AppBar, 'Source Management'), findsOneWidget);
    expect(find.text('Source Library'), findsOneWidget);
    expect(find.text('Demo Source'), findsOneWidget);
    expect(find.text('https://demo.example'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Search'), findsOneWidget);
    expect(find.text('Enter keywords'), findsOneWidget);
    expect(find.text('Run a search to see results.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu_book));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Bookshelf'), findsOneWidget);
    expect(find.text('Bookshelf content coming soon.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
    expect(find.text('Settings and preferences placeholder.'), findsOneWidget);
  });
}
