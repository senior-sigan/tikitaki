import 'package:flutter/material.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/shared/video_grid.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    required this.favoritesViewModel,
    required this.baseUrl,
    super.key,
  });

  final FavoritesViewModel favoritesViewModel;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListenableBuilder(
        listenable: favoritesViewModel,
        builder: (context, _) {
          final favorites = favoritesViewModel.favoriteVideos;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          return VideoGrid(videos: favorites, baseUrl: baseUrl);
        },
      ),
    );
  }
}
