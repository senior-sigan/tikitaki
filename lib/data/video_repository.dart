import 'package:tikitaki/data/video_item.dart';

abstract class VideoRepository {
  Future<List<VideoItem>> getVideos();
}
