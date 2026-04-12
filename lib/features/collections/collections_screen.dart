import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/core/widgets/app_scaffold.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({
    required this.collectionsViewModel,
    required this.baseUrl,
    super.key,
  });

  final CollectionsViewModel collectionsViewModel;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Collections',
      actions: [
        ListenableBuilder(
          listenable: collectionsViewModel,
          builder: (context, _) {
            final isNameSort =
                collectionsViewModel.sortOrder == CollectionSortOrder.name;
            return IconButton(
              icon: Icon(isNameSort ? Icons.sort_by_alpha : Icons.access_time),
              tooltip: isNameSort ? 'Sorted by name' : 'Sorted by date',
              onPressed: () {
                collectionsViewModel.setSortOrder(
                  isNameSort
                      ? CollectionSortOrder.apiOrder
                      : CollectionSortOrder.name,
                );
              },
            );
          },
        ),
      ],
      body: ListenableBuilder(
        listenable: collectionsViewModel,
        builder: (context, _) {
          final previews = collectionsViewModel.collectionPreviews;
          if (previews.isEmpty) {
            return const Center(child: Text('No collections'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 3 / 4,
            ),
            itemCount: previews.length,
            itemBuilder: (context, index) {
              final item = previews[index];
              final thumbnailUrl = resolveUrl(
                baseUrl,
                item.preview.thumbnailUrl,
              );
              return GestureDetector(
                onTap: () => context.go('/collections/${item.name}'),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: VideoThumbnail(thumbnailUrl: thumbnailUrl),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
