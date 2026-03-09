import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tikitaki/data/api_response.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';

class HttpVideoRepository implements VideoRepository {
  const HttpVideoRepository({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  @override
  Future<List<VideoItem>> getVideos() async {
    final response = await client.get(Uri.parse('$baseUrl/api'));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(json).items;
  }
}
