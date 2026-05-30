import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../api_services/api_client.dart';
import '../model/signup_model.dart';
import '../routes/app_routes.dart';

class RegisterController extends GetxController {

  /// Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// UI State
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  /// ================= SIGNUP =================
  Future<void> signup(GlobalKey<FormState> formKey) async {

    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final AuthResponseModel response = await AuthApi.signup(
        nameController.text.trim(),
        emailController.text.trim(),
        addressController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.success) {

        toastification.show(
          title: const Text("Account Created 🎉"),
          description: Text("Welcome ${response.data.name}"),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );

        Get.offAllNamed(AppRoutes.login);

      } else {
        toastification.show(
          title: const Text("Signup Failed"),
          description: Text(response.message),
          type: ToastificationType.error,
        );
      }

    } catch (e) {

      toastification.show(
        title: const Text("Error ❌"),
        description: Text(e.toString()),
        type: ToastificationType.error,
      );

    } finally {
      isLoading.value = false;
    }
  }


  /// ================= VALIDATORS =================

  String? validateName(String value) {
    if (value.isEmpty) return "Name is required";
    if (value.length < 3) return "Minimum 3 characters";
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return "Email required";
    if (!GetUtils.isEmail(value)) return "Enter valid email";
    return null;
  }

  String? validateDistrict(String value) {
    if (value.isEmpty) return "District is required";
    if (value.length < 2) return "Minimum 2 characters";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password required";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) return "Confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
