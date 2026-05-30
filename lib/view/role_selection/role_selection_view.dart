import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/SessionManger.dart';
import '../../routes/app_routes.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFE1F5FE)], // soft light blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(Icons.account_circle, size: 110.sp, color: Colors.blueGrey.shade300),

              SizedBox(height: 20.h),

              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 8.h),

              // Text(
              //   "Choose how you want to continue",
              //   style: TextStyle(fontSize: 16.sp, color: Colors.blueGrey.shade400),
              // ),

              SizedBox(height: 40.h),

              /// ADMIN CARD
              _roleCard(
                icon: Icons.admin_panel_settings,
                title: "Admin Panel",
                subtitle: "Manage videos, users & content",
                colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)], // light blue
                textColor: Colors.blueGrey.shade800,
                iconColor: Colors.blueGrey.shade700,
                  onTap: () async {
                    await SessionManager.setRole("admin");
                    Get.toNamed(AppRoutes.security);
                  }
              ),

              SizedBox(height: 20.h),

              /// CUSTOMER CARD
              _roleCard(
                icon: Icons.person,
                title: "Customer",
                subtitle: "Watch videos & explore courses",
                colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)], // light yellow
                textColor: Colors.blueGrey.shade800,
                iconColor: Colors.blueGrey.shade700,
                  onTap: () async {
                    await SessionManager.setRole("customer");
                    Get.toNamed(AppRoutes.login);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [

            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32.sp, color: iconColor),
            ),

            SizedBox(width: 18.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(color: textColor.withOpacity(0.75), fontSize: 13.sp),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded, size: 18.sp, color: textColor.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }
}
