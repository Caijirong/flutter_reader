import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_reader/features/search/search_controller.dart';
import 'package:flutter_reader/features/search/search_result_tile.dart';
import 'package:flutter_reader/data/models/search_book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.controller,
    this.onBookSelected,
  });

  final SearchController controller;
  final void Function(SearchBook book)? onBookSelected;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final keywords = _searchController.text.trim();
    if (keywords.isNotEmpty) {
      widget.controller.search(keywords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter keywords',
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              if (widget.controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (widget.controller.sourceResults.isEmpty) {
                return const Center(child: Text('Run a search to see results.'));
              }
              return ListView.builder(
                itemCount: widget.controller.sourceResults.length,
                itemBuilder: (context, index) {
                  final result = widget.controller.sourceResults[index];
                return SearchResultTile(
                  result: result,
                  onBookTap: (book) => widget.onBookSelected?.call(book),
                );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
