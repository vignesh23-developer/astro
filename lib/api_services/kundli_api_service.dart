import 'package:dio/dio.dart';
import '../model/kudli_model.dart';

class KundliApiService {

  final Dio dio = Dio();

  Future<KundliModel?> getKundli({
    required String datetime,
    required String coordinates,
  }) async {

    try {

      final response = await dio.get(
        "http://72.61.174.76:3000/api/prokerala/kundli-full",
        queryParameters: {
          "datetime": datetime,
          "coordinates": coordinates
        },
      );

      if (response.statusCode == 200) {
        return KundliModel.fromJson(response.data);
      }
      print("API Response: ${response.data}");
      print("API statusMessage: ${response.statusMessage}");
      print("API requestOptions: ${response.requestOptions}");

    } catch (e) {
      print("API ERROR $e");
    }

    return null;
  }
}