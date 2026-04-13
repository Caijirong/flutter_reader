import 'package:flutter/material.dart';
import 'package:flutter_reader/features/search/search_controller.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.result});

  final SearchResult result;

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
              )).toList(),
    );
  }
}
