import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/features/search/search_page.dart';
import 'package:flutter_reader/features/search/search_controller.dart' as search_ctrl;

import 'search_test_helpers.dart';

void main() {
  testWidgets('renders results and shows source-level errors', (tester) async {
    final repository = FakeBookRepository(
      responses: {
        'source-a': [makeTestBook('source-a', 'One')],
      },
      failingSources: {'source-b'},
    );
    final controller = search_ctrl.SearchController(
      repository: repository,
      sources: [makeTestSource('source-a'), makeTestSource('source-b')],
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchPage(controller: controller)),
    ));

    await tester.enterText(find.byType(TextField), 'keyword');
    await tester.tap(find.text('Search'));
    await tester.pump();

    expect(find.text('Source source-a'), findsOneWidget);
    expect(find.text('Source source-b'), findsOneWidget);
    expect(find.textContaining('Error:'), findsOneWidget);
  });
}
