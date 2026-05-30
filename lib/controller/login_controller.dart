import 'dart:developer';
import 'package:asrology/controller/video_controller.dart';
import 'package:asrology/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:toastification/toastification.dart';
import '../api_services/api_client.dart';
import '../model/login_model.dart';
import '../routes/SessionManger.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

 final VideoController videoController = Get.put(VideoController());

  Future<void> login(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await AuthApi.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.success == true) {


        // if (response.token != null) {
        //   await SessionManager.saveToken(response.token!);
        // }

        await videoController.fetchVideos();

        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          "Login Failed",
          response.message ?? "Invalid credentials",
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? e.message ?? "Something went wrong",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

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
