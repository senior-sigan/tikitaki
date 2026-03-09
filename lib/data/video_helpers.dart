import 'package:tikitaki/data/video_item.dart';

List<VideoItem> sortByCollection(List<VideoItem> videos) {
  final copy = List<VideoItem>.from(videos);
  copy.sort((a, b) => a.collection.compareTo(b.collection));
  return copy;
}

Map<String, List<VideoItem>> groupByCollection(List<VideoItem> videos) {
  final map = <String, List<VideoItem>>{};
  for (final video in videos) {
    map.putIfAbsent(video.collection, () => []).add(video);
  }
  return map;
}

List<VideoItem> getCollectionPreviews(List<VideoItem> videos) {
  final grouped = groupByCollection(videos);
  return grouped.values.map((list) => list.first).toList();
}
