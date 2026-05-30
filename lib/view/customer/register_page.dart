import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// 🔹 Logo
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/ALogo/logo.png",fit: BoxFit.cover,)
                  ),

                  SizedBox(height: 30.h),

                  /// 🔹 Title
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    "Sign up to get started",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 35.h),

                  /// 🔹 Form Card
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          _buildTextField(
                            controller.nameController,
                            "Full Name",
                            Icons.person_outline,
                                (value) =>
                                controller.validateName(value ?? ''),
                          ),

                          SizedBox(height: 18.h),

                          _buildTextField(
                            controller.emailController,
                            "Email Address",
                            Icons.email_outlined,
                                (value) =>
                                controller.validateEmail(value ?? ''),
                          ),

                          SizedBox(height: 18.h),

                          _buildTextField(
                            controller.addressController,
                            "District",
                            Icons.location_on_outlined,
                                (value) =>
                                controller.validateDistrict(value ?? ''),
                          ),

                          SizedBox(height: 18.h),

                          Obx(() => _buildTextField(
                            controller.passwordController,
                            "Password",
                            Icons.lock_outline,
                                (value) =>
                                controller.validatePassword(value ?? ''),
                            obscure: controller.isPasswordHidden.value,
                            suffix: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                              controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value,
                            ),
                          )),

                          SizedBox(height: 18.h),

                          Obx(() => _buildTextField(
                            controller.confirmPasswordController,
                            "Confirm Password",
                            Icons.lock_outline,
                                (value) => controller
                                .validateConfirmPassword(value ?? ''),
                            obscure:
                            controller.isConfirmPasswordHidden.value,
                            suffix: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                              controller
                                  .isConfirmPasswordHidden.value =
                              !controller
                                  .isConfirmPasswordHidden.value,
                            ),
                          )),

                          SizedBox(height: 30.h),

                          /// 🔹 Create Account Button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.signup(_formKey),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF6A5AE0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),

                          SizedBox(height: 25.h),

                          /// 🔹 Login Redirect
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => Get.offAllNamed(
                                    AppRoutes.login),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6A5AE0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      String? Function(String?) validator, {
        bool obscure = false,
        Widget? suffix,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        color: Colors.black, // ✅ Input text BLACK
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: Colors.deepPurple,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),

        // 🔹 Normal Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),

        // 🔹 Focus Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.deepPurple,
            width: 1.8,
          ),
        ),

        // 🔹 Error Border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}