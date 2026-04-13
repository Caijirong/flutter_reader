import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/app/app.dart';

void main() {
  testWidgets('app shell exposes the navigation tabs', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.widgetWithText(AppBar, 'Source Management'), findsOneWidget);
    expect(
      find.text('This is a placeholder for the Source Management tab'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Search'), findsOneWidget);
    expect(
      find.text('This is a placeholder for the Search tab'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.menu_book));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Bookshelf'), findsOneWidget);
    expect(
      find.text('This is a placeholder for the Bookshelf tab'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
    expect(
      find.text('This is a placeholder for the Settings tab'),
      findsOneWidget,
    );
  });
}
