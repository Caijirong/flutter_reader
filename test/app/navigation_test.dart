import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/app/app.dart';

void main() {
  testWidgets('navigates from sources through reader', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Source Management'), findsOneWidget);
    expect(find.text('Demo Source'), findsWidgets);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Search'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'demo');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    expect(find.text('Demo Source'), findsWidgets);
    expect(find.text('Demo Novel'), findsOneWidget);

    await tester.tap(find.text('Demo Novel'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Book Detail'), findsOneWidget);
    expect(find.text('Chapters'), findsOneWidget);
    await tester.tap(find.text('Chapter One'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Demo Novel'), findsOneWidget);
    expect(find.text('Chapter One'), findsWidgets);
    expect(find.text('This is demo content for chapter one.'), findsOneWidget);
  });
}
