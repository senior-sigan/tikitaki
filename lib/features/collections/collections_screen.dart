import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({
    required this.collectionsViewModel,
    required this.baseUrl,
    this.onCollectionTap,
    super.key,
  });

  final CollectionsViewModel collectionsViewModel;
  final String baseUrl;
  final VoidCallback? onCollectionTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),
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
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: previews.length,
            itemBuilder: (context, index) {
              final item = previews[index];
              final thumbnailUrl = resolveUrl(
                baseUrl,
                item.preview.thumbnailUrl,
              );
              return GestureDetector(
                onTap: onCollectionTap,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Icon(Icons.broken_image)),
                        ),
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
