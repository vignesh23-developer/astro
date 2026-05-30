import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../routes/SessionManger.dart';
import '../../routes/app_routes.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {

  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscure = true;

  void login() async{

    if (!formKey.currentState!.validate()) return;

    final password = passwordController.text.trim();

    if (AdminSecurity.validate(password)) {
     await SessionManager.setLoggedIn(true);
     await SessionManager.setRole("admin");
      toastification.show(
        context: context,
        title: const Text("Access Granted"),
        description: const Text("Welcome Admin"),
        type: ToastificationType.success,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(AppRoutes.adminDashboard);
      });

    } else {

      toastification.show(
        context: context,
        title: const Text("Access Denied"),
        description: const Text("Wrong Admin Password"),
        type: ToastificationType.error,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),

          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),

            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 60.sp,
                      color: Colors.deepPurple,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    "Admin Login",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 25.h),

                  /// PASSWORD FIELD
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      hintText: "Enter Admin Password",

                      filled: true,
                      fillColor: const Color(0xffF3F5F9),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => obscure = !obscure),
                      ),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? "Password required" : null,
                  ),

                  SizedBox(height: 22.h),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: login,
                      child: Text(
                        "Unlock Admin Panel",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Back to Role Selection",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AdminSecurity {

  static const String adminPassword = "YB2026@success";

  static bool validate(String password) {
    return password == adminPassword;
  }
}