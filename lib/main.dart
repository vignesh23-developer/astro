import 'package:asrology/controller/register_controller.dart';
import 'package:asrology/routes/app_routes.dart';
import 'package:asrology/view/admin/admin_home.dart';
import 'package:asrology/view/admin/admin_login_view.dart';
import 'package:asrology/view/admin/dashboard.dart';
import 'package:asrology/view/admin/upload_video.dart';
import 'package:asrology/view/customer/dashboard_view.dart';
import 'package:asrology/view/customer/login_view.dart';
import 'package:asrology/view/customer/profile_page.dart';
import 'package:asrology/view/customer/register_page.dart';
import 'package:asrology/view/role_selection/role_selection_view.dart';
import 'package:asrology/view/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'controller/video_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(VideoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Astrology Learning App',
          
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF0C0B20),
            ),
          
            initialRoute: AppRoutes.splashScreen,
          
            initialBinding: BindingsBuilder(() {
              Get.put(RegisterController(), permanent: true);
            }),
          
            getPages: [
              GetPage(
                name: AppRoutes.roleSelectionView,
                page: () => const RoleSelectionView(),
              ),
              GetPage(
                name: AppRoutes.splashScreen,
                page: () => const Splashscreen(),
              ),
              GetPage(
                name: AppRoutes.security,
                page: () => const AdminLoginView(),
              ),
              GetPage(
                name: AppRoutes.login,
                page: () => LoginView(),
              ),
              GetPage(
                name: AppRoutes.register,
                page: () => RegisterView(),
              ),
              GetPage(
                name: AppRoutes.dashboard,
                page: () => const DashboardView(),
              ),
              GetPage(
                name: AppRoutes.profileScreen,
                page: () => const ProfileScreen(),
              ),
              GetPage(
                name: AppRoutes.adminDashboard,
                page: () =>  AdminBottom(),
              ),
              GetPage(
                name: AppRoutes.manageVideosScreen,
                page: () =>  UploadPage(),
              ),
              GetPage(
                name: AppRoutes.manageUsersScreen,
                page: () =>  AdminHome(),
              ),
            ],
          ),
        );
      },
    );
  }
}
