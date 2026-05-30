class CustomerVideoModel {
  final bool success;
  final String message;
  final CustomerVideoCategory free;
  final CustomerVideoCategory entry;
  final CustomerVideoCategory advance;
  final bool hasEntry;
  final bool hasAdvance;

  CustomerVideoModel({
    required this.success,
    required this.message,
    required this.free,
    required this.entry,
    required this.advance,
    required this.hasEntry,
    required this.hasAdvance,
  });

  factory CustomerVideoModel.fromJson(Map<String, dynamic> json) {
    return CustomerVideoModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      free: CustomerVideoCategory.fromJson(json['free'] ?? {}),
      entry: CustomerVideoCategory.fromJson(json['entry'] ?? {}),
      advance: CustomerVideoCategory.fromJson(json['advance'] ?? {}),
      hasEntry: json['hasEntry'] ?? false,
      hasAdvance: json['hasAdvance'] ?? false,
    );
  }
}

class CustomerVideoCategory {
  final String type;
  final int count;
  final List<CustomerVideoItem> videos;

  CustomerVideoCategory({
    required this.type,
    required this.count,
    required this.videos,
  });

  factory CustomerVideoCategory.fromJson(Map<String, dynamic> json) {
    return CustomerVideoCategory(
      type: json['type'] ?? '',
      count: json['count'] ?? json['Tcount'] ?? 0,
      videos: (json['videos'] as List?)
          ?.map((e) => CustomerVideoItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CustomerVideoItem {
  final String id;
  final String videoUrl;

  CustomerVideoItem({
    required this.id,
    required this.videoUrl,
  });

  factory CustomerVideoItem.fromJson(Map<String, dynamic> json) {
    return CustomerVideoItem(
      id: json['id'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}