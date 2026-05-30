import 'dart:convert';
import 'package:http/http.dart' as http;

class ProkeralaApiService {
  static const String _baseUrl = 'https://api.prokerala.com/v2/astrology';
  static const String _tokenUrl = 'https://api.prokerala.com/token';

  final String clientId;
  final String clientSecret;

  String? _accessToken;
  DateTime? _tokenExpiry;

  ProkeralaApiService({
    required this.clientId,
    required this.clientSecret,
  });

  /// ───────────────── TOKEN ─────────────────
  Future<String> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      print("Using cached token");
      return _accessToken!;
    }

    print("Requesting new access token...");

    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Token Error: ${response.body}");
    }

    final data = jsonDecode(response.body);

    _accessToken = data['access_token'];
    _tokenExpiry = DateTime.now().add(
      Duration(seconds: (data['expires_in'] as int) - 60),
    );

    return _accessToken!;
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// ───────────────── SAFE JSON CONVERTER ─────────────────
  dynamic _convertToSafe(dynamic value) {
    if (value is Map) {
      return value.map(
            (key, val) => MapEntry(key.toString(), _convertToSafe(val)),
      );
    } else if (value is List) {
      return value.map((e) => _convertToSafe(e)).toList();
    }
    return value;
  }

  /// ───────────────── HELPER ─────────────────
  String _formatDateTime(DateTime dt) {
    final offset = dt.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';

    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes =
    (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return "${dt.toIso8601String().split('.').first}$sign$hours:$minutes";
  }

  Map<String, String> _commonParams({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) {
    return {
      'datetime': _formatDateTime(dateTime),
      'coordinates': '$latitude,$longitude',
      'ayanamsa': '1',
    };
  }

  /// ───────────────── GENERIC GET ─────────────────
  Future<Map<String, dynamic>> _get(
      String endpoint,
      Map<String, String> params,
      ) async {
    final headers = await _authHeaders();

    final uri = Uri.parse('$_baseUrl/$endpoint')
        .replace(queryParameters: params);

    print("API Request: $uri");

    final response = await http.get(uri, headers: headers);

    print("Status: ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception("API Error: ${response.body}");
    }

    final decoded = jsonDecode(response.body);

    if (decoded["status"] != "ok") {
      throw Exception("API returned error: ${response.body}");
    }

    /// ✅ FULL SAFE CONVERSION (FIXES YOUR ERROR)
    return Map<String, dynamic>.from(
      _convertToSafe(decoded["data"]),
    );
  }

  /// ───────────────── API CALLS ─────────────────

  Future<Map<String, dynamic>> getBirthDetails({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
    required String gender,
  }) async {
    final params = _commonParams(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    params["gender"] = gender;

    return await _get("kundli", params);
  }

  Future<Map<String, dynamic>> getPlanetPositions({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "planet-position",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  Future<Map<String, dynamic>> getMangalDosha({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "mangal-dosha",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  Future<Map<String, dynamic>> getKaalSarpDosha({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "kaal-sarp-dosha",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  Future<Map<String, dynamic>> getYogaDetails({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "yoga",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  Future<Map<String, dynamic>> getVimsottariDasha({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "dasha-periods",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  Future<Map<String, dynamic>> getSadeSati({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    return await _get(
      "sade-sati",
      _commonParams(
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      ),
    );
  }

  /// ───────────────── FULL REPORT ─────────────────
  Future<Map<String, dynamic>> getFullBirthChartReport({
    required String name,
    required double latitude,
    required double longitude,
    required DateTime dateTime,
    required String gender,
  }) async {
    final birthDetails = await getBirthDetails(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
      gender: gender,
    );

    final planets = await getPlanetPositions(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    final mangal = await getMangalDosha(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    final kaalSarp = await getKaalSarpDosha(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    final yoga = await getYogaDetails(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    final dasha = await getVimsottariDasha(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    final sadeSati = await getSadeSati(
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    return {
      "name": name,
      "date_time": dateTime.toIso8601String(),
      "place_of_birth": "$latitude,$longitude",

      /// ✅ CLEAN DATA (NO EXTRA ['data'])
      "birth_details": birthDetails,
      "planet_position": planets,
      "mangal_dosha": mangal,
      "kaal_sarp": kaalSarp,
      "yoga_details": yoga,
      "dasha": dasha,
      "sade_sati": sadeSati,
    };
  }
}