import 'package:asrology/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
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
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/ALogo/logo.png",fit: BoxFit.cover,)
                  ),

                  SizedBox(height: 30.h),

                  /// 🔹 Title
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 35.h),

                  /// 🔹 Login Card
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 30.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          /// Email
                          _buildTextField(
                            controller.emailController,
                            "Email Address",
                            Icons.email_outlined,
                                (value) =>
                                controller.validateEmail(value ?? ''),
                          ),

                          SizedBox(height: 20.h),

                          /// Password
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

                          SizedBox(height: 25.h),

                          /// Login Button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.login(_formKey),
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
                                "Sign In",
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

                          /// Register Link
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () =>
                                    Get.offAllNamed(AppRoutes.register),
                                child: Text(
                                  "Sign Up",
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
      cursorColor: const Color(0xFF6A5AE0),
      style: const TextStyle(
        color: Colors.black, // ✅ Black input text
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
          color: Color(0xFF6A5AE0),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF6A5AE0),
            width: 1.8,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}