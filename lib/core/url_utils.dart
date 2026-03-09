String resolveUrl(String baseUrl, String relativePath) {
  final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
  final path = relativePath.startsWith('/') ? relativePath : '/$relativePath';
  return '$base$path';
}
