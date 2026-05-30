class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileData {
  final String id;
  final int userId;
  final String name;
  final String email;
  final String address;
  final String dob;
  final String birthPlace;

  ProfileData({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.address,
    required this.dob,
    required this.birthPlace,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id']?.toString() ?? "",
      userId: json['userId'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
      dob: json['dob'] ?? "",
      birthPlace: json['birthPlace'] ?? "",
    );
  }
}