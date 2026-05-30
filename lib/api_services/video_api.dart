import 'package:asrology/model/customer_video_model.dart';
import 'package:asrology/routes/SessionManger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api_services/api_client.dart';
import '../api_services/api_routes.dart';
import '../model/admin_video_model.dart';
import '../model/profile_model.dart';
import '../model/video_model.dart';

class VideoApiService {

  /// ================= FETCH VIDEOS =================
  static Future<VideoResponse> fetchVideos(String userId) async {

    final response = await ApiClient.dio.post(
      ApiRoutes.videos,
      data: {
        "userId": "1",
      },
    );

    if (response.statusCode == 200) {
      return VideoResponse.fromJson(response.data);
    } else {
      throw Exception("Server Error");
    }
  }

  static Future<CustomerVideoModel> fetchCVideos() async {
    String? userId = await SessionManager.getUserId();
    final response = await ApiClient.dio.post(
      ApiRoutes.videos,
      data: {
        "userId": userId ?? "1",
      },
    );

    if (response.statusCode == 200) {
      return CustomerVideoModel.fromJson(response.data);
    } else {
      throw Exception("Server Error");
    }
  }

  /// ================= UPLOAD VIDEO =================
  static Future<dynamic> uploadVideoToBackend({
    required String videoUrl,
    required String type,
  }) async {

    final Dio dio = Dio();

    final String url = "http://72.61.174.76:3000/api/videos";

    final response = await dio.post(
      url,
      data: {
        "videoUrl": videoUrl,
        "type": type,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    return response.data;
  }

  static Future<AdminVideoResponse> getAllVideos() async {
    final response = await ApiClient.dio.get(
      ApiRoutes.adminVideos,
    );

    return AdminVideoResponse.fromJson(response.data);
  }


  /// DELETE VIDEO
  static Future<bool> deleteVideo(String id) async {

    final response = await ApiClient.dio.delete(
      "${ApiRoutes.uploadVideos}/$id",
    );

    return response.statusCode == 200;
  }


  static Future<ProfileResponse> uploadProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String dob,
  }) async {

    final Dio dio = Dio();
    String? userId = await SessionManager.getUserId();

    debugPrint("========= UPDATE PROFILE API =========");
    debugPrint("URL: ${ApiRoutes.updateProfile}");
    debugPrint("UserId: $userId");
    debugPrint("Name: $name");
    debugPrint("Email: $email");
    debugPrint("Phone: $phone");
    debugPrint("Address: $address");
    debugPrint("DOB: $dob");

    try {

      final response = await dio.post(
        ApiRoutes.updateProfile,
        data: {
          "userId": int.parse(userId ?? "0"),
          "name": name,
          "email": email,
          "phone": phone,
          "address": address,
          "dob": dob,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("========= API RESPONSE =========");
      debugPrint(response.data.toString());

      return ProfileResponse.fromJson(response.data);

    } on DioException catch (e) {

      debugPrint("========= API ERROR =========");
      debugPrint(e.toString());
      debugPrint("Response: ${e.response?.data}");

      throw Exception(e.response?.data ?? "Profile update failed");
    }
  }
  static Future<ProfileResponse> getProfile(int userId) async {

    debugPrint("===== GET PROFILE API =====");
    debugPrint("UserId: $userId");

    final response = await ApiClient.dio.get(
      ApiRoutes.getProfile(userId),
    );

    debugPrint("PROFILE RESPONSE: ${response.data}");

    return ProfileResponse.fromJson(response.data);
  }
  static Future<dynamic> savePayment({
    required int userId,
    required String paymentType,
    required String paymentId,
    required int amount,
  }) async {

    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.savePayment,
        data: {
          "userId": userId,
          "paymentType": paymentType,
          "razorpayPaymentId": paymentId,
          "amount": amount,
        },
      );

      debugPrint("💰 SAVE PAYMENT RESPONSE: ${response.data}");

      return response.data;

    } catch (e) {
      debugPrint("❌ SAVE PAYMENT ERROR: $e");
      throw Exception("Payment save failed");
    }
  }
  static Future<Map<String, dynamic>> getPaymentStatus(int userId) async {

    try {
      final response = await ApiClient.dio.get(
        ApiRoutes.getPaymentStatus(userId),
      );

      debugPrint("💰 PAYMENT STATUS RESPONSE: ${response.data}");

      return response.data;

    } catch (e) {
      debugPrint("❌ PAYMENT STATUS ERROR: $e");
      throw Exception("Payment status failed");
    }
  }
}