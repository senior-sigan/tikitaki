import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/app_router.dart';
import 'package:tikitaki/core/widgets/app_scaffold.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/core/widgets/video_grid.dart';

class CollectionDetailScreen extends StatefulWidget {
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
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  var _sortOrder = CollectionSortOrder.apiOrder;

  List<VideoItem> _sortedVideos(List<VideoItem> videos) {
    if (_sortOrder == CollectionSortOrder.apiOrder) return videos;
    final sorted = List<VideoItem>.of(videos);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final isNameSort = _sortOrder == CollectionSortOrder.name;
    return AppScaffold(
      title: widget.collectionName,
      actions: [
        IconButton(
          icon: Icon(isNameSort ? Icons.sort_by_alpha : Icons.access_time),
          tooltip: isNameSort ? 'Sorted by name' : 'Sorted by date',
          onPressed: () {
            setState(() {
              _sortOrder = isNameSort
                  ? CollectionSortOrder.apiOrder
                  : CollectionSortOrder.name;
            });
          },
        ),
      ],
      body: ListenableBuilder(
        listenable: widget.collectionsViewModel,
        builder: (context, _) {
          final videos =
              widget.collectionsViewModel.collections[widget.collectionName];
          if (videos == null || videos.isEmpty) {
            return const Center(child: Text('No videos in this collection'));
          }
          final sorted = _sortedVideos(videos);
          return VideoGrid(
            videos: sorted,
            baseUrl: widget.baseUrl,
            onVideoTap: (video, index) {
              context.push(
                '/player',
                extra: PlayerRouteData(videos: sorted, startIndex: index),
              );
            },
          );
        },
      ),
    );
  }
}
