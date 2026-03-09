import 'package:tikitaki/data/video_item.dart';

class ApiResponse {
  const ApiResponse({required this.items});

  final List<VideoItem> items;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>;
    return ApiResponse(
      items: itemsList
          .map((item) => VideoItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
