import 'package:asrology/view/admin/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'admin_home.dart';

class AdminBottom extends StatefulWidget {
  const AdminBottom({super.key});

  @override
  State<AdminBottom> createState() => _AdminBottomState();
}

class _AdminBottomState extends State<AdminBottom> {
  int selectedIndex = 0;

  final pages = [AdminHome(), const UploadPage()];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: const Color(0xff6C63FF),
        activeColor: Colors.white,
        color: Colors.white70,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.upload_file, title: 'Upload'),
        ],
        initialActiveIndex: 0,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}




