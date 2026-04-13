import 'package:flutter/material.dart';

import 'package:flutter_reader/app/routes.dart';
import 'package:flutter_reader/app/demo/demo_data.dart';
import 'package:flutter_reader/app/demo/demo_repository.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';
import 'package:flutter_reader/features/book/book_detail_controller.dart';
import 'package:flutter_reader/features/book/book_detail_page.dart';
import 'package:flutter_reader/features/reader/reader_controller.dart';
import 'package:flutter_reader/features/reader/reader_page.dart';
import 'package:flutter_reader/features/search/search_controller.dart' as search_ctrl;
import 'package:flutter_reader/features/search/search_page.dart';
import 'package:flutter_reader/features/sources/source_import_controller.dart';
import 'package:flutter_reader/features/sources/source_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final bookRepository = DemoBookRepository(sources: DemoData.sources);
    final readerRepository = DemoReaderRepository();
    final searchController = search_ctrl.SearchController(
      repository: bookRepository,
      sources: DemoData.sources,
    );
    final sourceController = SourceImportController(initialSources: DemoData.sources);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Legado Reader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AppShell(
        sourcesController: sourceController,
        searchController: searchController,
        bookRepository: bookRepository,
        readerRepository: readerRepository,
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.sourcesController,
    required this.searchController,
    required this.bookRepository,
    required this.readerRepository,
  });

  final SourceImportController sourcesController;
  final search_ctrl.SearchController searchController;
  final BookRepository bookRepository;
  final ReaderRepository readerRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _destinations;

  Future<void> _openDetail(BuildContext context, SearchBook book) async {
    final controller = BookDetailController(
      repository: widget.bookRepository,
      source: DemoData.bookSource,
      searchBook: book,
    );

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookDetailPage(
        controller: controller,
        onChapterSelected: (detailBook, chapter) async {
          await _openReader(context, detailBook); // launches reader
        },
      ),
    ));
  }

  Future<void> _openReader(BuildContext context, Book book) async {
    final chapters = book.chapters ?? DemoData.chapters;
    final readerController = ReaderController(
      repository: widget.readerRepository,
      book: book,
      chapters: chapters,
    );

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReaderPage(controller: readerController),
    ));
  }

  @override
  void initState() {
    super.initState();
    _destinations = [
      SourceListPage(controller: widget.sourcesController),
      SearchPage(
        controller: widget.searchController,
        onBookSelected: (book) async => _openDetail(context, book),
      ),
      const Scaffold(body: Center(child: Text('Bookshelf content coming soon.'))),
      const Scaffold(body: Center(child: Text('Settings and preferences placeholder.'))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = appRoutes[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text(currentRoute.title)),
      body: IndexedStack(
        index: _currentIndex,
        children: _destinations,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: appRoutes
            .map((route) => NavigationDestination(icon: Icon(route.icon), label: route.title))
            .toList(),
      ),
    );
  }
}
