import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/app_router.dart';
import 'package:tikitaki/core/widgets/app_scaffold.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';
import 'package:tikitaki/core/widgets/video_grid.dart';

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
    return AppScaffold(
      title: 'History',
      body: ListenableBuilder(
        listenable: videoListViewModel,
        builder: (context, _) {
          return switch (videoListViewModel.state) {
            VideoListState.initial || VideoListState.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            VideoListState.loaded => RefreshIndicator(
              onRefresh: videoListViewModel.refresh,
              child: VideoGrid(
                videos: videoListViewModel.videos,
                baseUrl: baseUrl,
                onVideoTap: (video, index) {
                  context.push(
                    '/player',
                    extra: PlayerRouteData(
                      videos: videoListViewModel.videos,
                      startIndex: index,
                    ),
                  );
                },
              ),
            ),
            VideoListState.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(videoListViewModel.errorMessage ?? 'Unknown error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: videoListViewModel.load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
