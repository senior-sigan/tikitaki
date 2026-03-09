import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _icons = [
    Icons.history,
    Icons.collections,
    Icons.favorite,
    Icons.settings,
  ];

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.9,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_icons.length, (index) {
                    final isSelected = index == navigationShell.currentIndex;
                    return IconButton(
                      icon: Icon(_icons[index]),
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      onPressed: () => _onTabTapped(index),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
