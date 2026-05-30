class UploadVideoResponse {
  final bool success;
  final String message;
  final VideoData data;

  UploadVideoResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UploadVideoResponse.fromJson(Map<String, dynamic> json) {
    return UploadVideoResponse(
      success: json['success'],
      message: json['message'],
      data: VideoData.fromJson(json['data']),
    );
  }
}

class VideoData {
  final String id;
  final String type;
  final String videoUrl;
  final String createdAt;
  final String updatedAt;

  VideoData({
    required this.id,
    required this.type,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      id: json['_id'],
      type: json['type'],
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}