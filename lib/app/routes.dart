import 'package:flutter/material.dart';

class AppRoute {
  final String title;
  final String placeholder;
  final IconData icon;

  const AppRoute({
    required this.title,
    required this.placeholder,
    required this.icon,
  });
}

const List<AppRoute> appRoutes = [
  AppRoute(
    title: 'Source Management',
    placeholder: 'This is a placeholder for the Source Management tab',
    icon: Icons.storage,
  ),
  AppRoute(
    title: 'Search',
    placeholder: 'This is a placeholder for the Search tab',
    icon: Icons.search,
  ),
  AppRoute(
    title: 'Bookshelf',
    placeholder: 'This is a placeholder for the Bookshelf tab',
    icon: Icons.menu_book,
  ),
  AppRoute(
    title: 'Settings',
    placeholder: 'This is a placeholder for the Settings tab',
    icon: Icons.settings,
  ),
];
