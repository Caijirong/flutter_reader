import 'package:flutter/material.dart';

class AppRoute {
  final String title;
  final IconData icon;

  const AppRoute({
    required this.title,
    required this.icon,
  });
}

const List<AppRoute> appRoutes = [
  AppRoute(title: 'Source Management', icon: Icons.storage),
  AppRoute(title: 'Search', icon: Icons.search),
  AppRoute(title: 'Bookshelf', icon: Icons.menu_book),
  AppRoute(title: 'Settings', icon: Icons.settings),
];
