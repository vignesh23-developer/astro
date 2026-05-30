class VideoResponse {
  final bool success;
  final String message;
  final List<VideoCategory> type;
  final List<VideoCategory> type2;
  final List<VideoCategory> type3;

  VideoResponse({
    required this.success,
    required this.message,
    required this.type,
    required this.type2,
    required this.type3,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      type: (json['type'] as List?)
          ?.map((e) => VideoCategory.fromJson(e))
          .toList() ??
          [],
      type2: (json['type2'] as List?)
          ?.map((e) => VideoCategory.fromJson(e))
          .toList() ??
          [],
      type3: (json['type3'] as List?)
          ?.map((e) => VideoCategory.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class VideoCategory {
  final String type;
  final int count;
  final List<VideoItem> videos;

  VideoCategory({
    required this.type,
    required this.count,
    required this.videos,
  });

  factory VideoCategory.fromJson(Map<String, dynamic> json) {
    return VideoCategory(
      type: json['type'] ?? '',
      count: json['Tcount'] ?? json['count'] ?? 0,
      videos: (json['videos'] as List?)
          ?.map((e) => VideoItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class VideoItem {
  final String id;
  final String videoUrl;

  VideoItem({
    required this.id,
    required this.videoUrl,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}