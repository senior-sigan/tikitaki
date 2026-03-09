class VideoItem {
  const VideoItem({
    required this.url,
    required this.name,
    required this.collection,
    required this.thumbnailUrl,
  });

  final String url;
  final String name;
  final String collection;
  final String thumbnailUrl;

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      url: json['url'] as String,
      name: json['name'] as String,
      collection: json['collection'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
    );
  }
}
