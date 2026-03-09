import 'package:flutter/material.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';
import 'package:tikitaki/features/shared/video_grid.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    required this.videoListViewModel,
    required this.favoritesViewModel,
    required this.baseUrl,
    super.key,
  });

  final VideoListViewModel videoListViewModel;
  final FavoritesViewModel favoritesViewModel;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListenableBuilder(
        listenable: videoListViewModel,
        builder: (context, _) {
          return switch (videoListViewModel.state) {
            VideoListState.initial || VideoListState.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            VideoListState.loaded => VideoGrid(
              videos: videoListViewModel.videos,
              baseUrl: baseUrl,
            ),
            VideoListState.error => Center(
              child: Text(videoListViewModel.errorMessage ?? 'Unknown error'),
            ),
          };
        },
      ),
    );
  }
}
