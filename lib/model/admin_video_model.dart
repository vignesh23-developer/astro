class AdminVideoResponse {
  final bool success;
  final String message;
  final VideoSection freeVideos;
  final VideoSection entryVideos;
  final VideoSection advanceVideos;

  AdminVideoResponse({
    required this.success,
    required this.message,
    required this.freeVideos,
    required this.entryVideos,
    required this.advanceVideos,
  });

  factory AdminVideoResponse.fromJson(Map<String, dynamic> json) {
    return AdminVideoResponse(
      success: json["success"],
      message: json["message"],
      freeVideos: VideoSection.fromJson(json["freeVideos"]),
      entryVideos: VideoSection.fromJson(json["entryVideos"]),
      advanceVideos: VideoSection.fromJson(json["advanceVideos"]),
    );
  }
}

class VideoSection {
  final int count;
  final List<VideoModel> videos;

  VideoSection({required this.count, required this.videos});

  factory VideoSection.fromJson(Map<String, dynamic> json) {
    return VideoSection(
      count: json["count"],
      videos: List<VideoModel>.from(
        (json["videos"] as List<dynamic>).map((e) => VideoModel.fromJson(e)),
      ),
    );
  }
}

class VideoModel {
  final String id;
  final String videoUrl;
  final String type;

  VideoModel({required this.id, required this.videoUrl, required this.type});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json["id"],
      videoUrl: json["videoUrl"],
      type: json["type"],
    );
  }
}
