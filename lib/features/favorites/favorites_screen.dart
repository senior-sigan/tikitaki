import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/app_router.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/core/widgets/video_grid.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Favorites'),
            forceElevated: innerBoxIsScrolled,
          ),
        ],
        body: ListenableBuilder(
          listenable: favoritesViewModel,
          builder: (context, _) {
            final favorites = favoritesViewModel.favoriteVideos;
            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }
            return VideoGrid(
              videos: favorites,
              baseUrl: baseUrl,
              onVideoTap: (video, index) {
                context.push(
                  '/player',
                  extra: PlayerRouteData(videos: favorites, startIndex: index),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
