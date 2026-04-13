import 'package:flutter/material.dart';
import 'package:flutter_reader/features/search/search_controller.dart';
import 'package:flutter_reader/data/models/search_book.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.result,
    this.onBookTap,
  });

  final SearchResult result;
  final void Function(SearchBook book)? onBookTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(result.source.name),
      subtitle: result.error == null ? const Text('') : Text('Error: ${result.error}'),
      children: result.error != null
          ? []
          : result.books.map((book) => ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => onBookTap?.call(book),
              )).toList(),
    );
  }
}
