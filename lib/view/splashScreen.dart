import 'package:asrology/view/role_selection/role_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../routes/SessionManger.dart';
import '../routes/app_routes.dart';
import 'admin/dashboard.dart';
import 'customer/dashboard_view.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    navigateNext();
  }

  Future<void> navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final roleSelected = await SessionManager.isRoleSelected();
    final isLoggedIn = await SessionManager.isLoggedIn();
    final role = await SessionManager.getUserRole();

    /// First time open
    if (!roleSelected) {
      Get.offAll(() => const RoleSelectionView());
      return;
    }

    /// Role selected but not logged in
    if (!isLoggedIn) {
      if (role == "admin") {
        Get.offAllNamed(AppRoutes.security);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }

      return;
    }

    /// Logged in user
    if (role == "admin") {
      Get.offAll(() => AdminBottom());
    } else {
      Get.offAll(() => const DashboardView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO
            Container(
              height: 300.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/ALogo/logo.png', fit: BoxFit.contain),
            ),

            SizedBox(height: 12.h),

            /// TITLE
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'யாமிருக்க பயமேன்',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'ஜோதிட பயிற்சி நிலையம்',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// LOADER
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
