import '../app_constants.dart';

class ApiRoutes {
  static String signup = AppConstants.baseUrl + AppConstants.signup;
  static String login = AppConstants.baseUrl + AppConstants.login;
  static String videos = AppConstants.baseUrl + AppConstants.videos;
  static String uploadVideos = AppConstants.baseUrl + AppConstants.upload;
  static String adminVideos = AppConstants.baseUrl + AppConstants.allVideos;
  static String updateProfile = AppConstants.baseUrl + AppConstants.updatedProfile;
  static String getProfile(int id) => "${AppConstants.baseUrl}${AppConstants.getProfile}/$id";
  static String savePayment =
      AppConstants.baseUrl + AppConstants.savePayment;

  static String getPaymentStatus(int userId) =>
      "${AppConstants.baseUrl}${AppConstants.paymentStatus}/$userId";

}
