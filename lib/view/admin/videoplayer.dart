import 'package:asrology/controller/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

 final VideoController videoController = Get.put(VideoController());

// Future<void> login(GlobalKey<FormState> formKey) async {
//   if (!formKey.currentState!.validate()) return;
//
//   try {
//     isLoading.value = true;
//
//     // 🔹 LOGIN API
//     final success = await AuthService.login(
//       emailController.text,
//       passwordController.text,
//     );
//
//     if (success) {
//
//       /// ✅ IMPORTANT
//       await videoController.fetchVideos();
//
//       /// ✅ AFTER FETCH ONLY NAVIGATE
//       Get.offAllNamed(AppRoutes.dashboard);
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   } finally {
//     isLoading.value = false;
//   }
// }

  String? validateEmail(String value) {
    if (value.isEmpty) return "Email required";
    if (!GetUtils.isEmail(value)) return "Enter valid email";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password required";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
