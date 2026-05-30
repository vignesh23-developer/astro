import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class AppConstants {
  static const String baseUrl = "http://72.61.174.76:3000";

  static const String signup = "/api/auth/signup";
  static const String login = "/api/auth/login";
  static const String videos = "/api/videos/structured";
  static const String upload = "/api/videos";
  static const String allVideos = "/api/videos/all";
  static const String updatedProfile = "/api/profile/update";
  static const String getProfile  = "/api/profile";
  static const String savePayment = "/api/payment/save-payment";
  static const String paymentStatus = "/api/payment/status";
}




void openGoogleForm() async {
  final url = Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSfSwfOvl48X_HLgBkNg4L1IA3NR5GgWyJs_JR4WV5j6MkeGNQ/viewform?usp=publish-editor");

  await launchUrl(url, mode: LaunchMode.externalApplication);
}


class GradientHelper {
  static List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    const LinearGradient(
      colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
    ),
    const LinearGradient(
      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    const LinearGradient(
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
    const LinearGradient(
      colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    ),
  ];

  static LinearGradient getGradient(int index) {
    return gradients[index % gradients.length];
  }
}

