import 'package:get/get.dart';
import '../api_services/video_api.dart';
import '../model/profile_model.dart';
import '../routes/SessionManger.dart';

class ProfileController extends GetxController {

  var isLoading = false.obs;

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String dob,
  }) async {

    try {

      isLoading(true);

      final ProfileResponse response = await VideoApiService.uploadProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        dob: dob,
      );

      if (response.success == true) {

        Get.snackbar(
          "Success",
          response.message ?? "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

      } else {

        Get.snackbar(
          "Error",
          response.message ?? "Profile update failed",
          snackPosition: SnackPosition.BOTTOM,
        );

      }

    } catch (e) {

      print("PROFILE UPDATE ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

    } finally {

      isLoading(false);

    }
  }
  Future<void> fetchProfile() async {

    try {

      isLoading(true);

      String? userId = await SessionManager.getUserId();

      final ProfileResponse response =
      await VideoApiService.getProfile(int.parse(userId!));

      if (response.success == true) {

        print("PROFILE DATA: ${response.data}");

      }

    } catch (e) {

      print("GET PROFILE ERROR: $e");

    } finally {

      isLoading(false);

    }
  }
}