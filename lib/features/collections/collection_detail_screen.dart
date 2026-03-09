import 'package:flutter/material.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/shared/video_grid.dart';

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({
    required this.collectionName,
    required this.collectionsViewModel,
    required this.favoritesViewModel,
    required this.baseUrl,
    super.key,
  });

  final String collectionName;
  final CollectionsViewModel collectionsViewModel;
  final FavoritesViewModel favoritesViewModel;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(collectionName)),
      body: ListenableBuilder(
        listenable: collectionsViewModel,
        builder: (context, _) {
          final videos = collectionsViewModel.collections[collectionName];
          if (videos == null || videos.isEmpty) {
            return const Center(child: Text('No videos in this collection'));
          }
          return VideoGrid(videos: videos, baseUrl: baseUrl);
        },
      ),
    );
  }
}
