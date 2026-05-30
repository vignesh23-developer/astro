import 'package:dio/dio.dart';
import '../model/login_model.dart';
import '../model/signup_model.dart';
import 'api_routes.dart';

class ApiClient {
  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );
}

class AuthApi {

  static Future<LoginResponseModel> login(
      String email,
      String password,
      ) async {
    print("Login API Call Start");
    final response = await ApiClient.dio.post(
      ApiRoutes.login,
      data: {
        "email": email,
        "password": password,
      },
    );
    print("Login API Respons: ${response.data}");
    return LoginResponseModel.fromJson(response.data);
  }

  static Future<AuthResponseModel> signup(
      String name,
      String email,
      String address,
      String password,
      ) async {
    final response = await ApiClient.dio.post(
      ApiRoutes.signup,
      data: {
        "name": name,
        "email": email,
        "address": address,
        "password": password,
      },
    );
    return AuthResponseModel.fromJson(response.data);
  }
}