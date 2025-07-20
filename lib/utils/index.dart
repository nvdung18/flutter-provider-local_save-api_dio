class Utils {
  static List<T> parseListResponse<T>(
    dynamic data,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = (data is Map && data[key] != null)
        ? data[key]
        : (data is List ? data : []);
    return List<T>.from(list.map((e) => fromJson(e)));
  }
}
