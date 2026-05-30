// ═══════════════════════════════════════════════════════════════
//  Birth Chart Models — maps to Prokerala API v2 response shapes
// ═══════════════════════════════════════════════════════════════

// ── Helper for safe string extraction ─────────────────────────
String _safeString(dynamic value) => value?.toString() ?? '';

// ── Planet Position ────────────────────────────────────────────

class Planet {
  final String name;
  final int position;
  final double degree;
  final bool isRetrograde;
  final String rasi;
  final String rasiLord;

  Planet({
    required this.name,
    required this.position,
    required this.degree,
    required this.isRetrograde,
    required this.rasi,
    required this.rasiLord,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: _safeString(json['name']),
      position: (json['position'] ?? 0).toInt(),
      degree: (json['degree'] ?? 0).toDouble(),
      isRetrograde: json['is_retrograde'] ?? false,
      rasi: _safeString(json['rasi']?['name']),
      rasiLord: _safeString(json['rasi']?['lord']?['name']),
    );
  }
}

class PlanetPositionResult {
  final List<Planet> planets;
  final Planet? ascendant;

  const PlanetPositionResult({
    required this.planets,
    this.ascendant,
  });

  factory PlanetPositionResult.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] as Map<String, dynamic>?) ?? j;

    final planetList = (data['planet_position'] as List? ?? [])
        .map((p) => Planet.fromJson(p as Map<String, dynamic>))
        .toList();

    Planet? asc;
    if (data['ascendant'] != null) {
      asc = Planet.fromJson(data['ascendant'] as Map<String, dynamic>);
    }

    return PlanetPositionResult(
      planets: planetList,
      ascendant: asc,
    );
  }
}

// ── Birth Details (Kundli) ─────────────────────────────────────

class BirthDetailsResult {
  final String nakshatra;
  final int nakshatraPada;
  final String chandraRasi;
  final String sooryaRasi;
  final String zodiac;

  BirthDetailsResult({
    required this.nakshatra,
    required this.nakshatraPada,
    required this.chandraRasi,
    required this.sooryaRasi,
    required this.zodiac,
  });

  factory BirthDetailsResult.fromJson(Map<String, dynamic> json) {
    final nak = json['nakshatra_details']?['nakshatra'] ?? {};
    final chandra = json['nakshatra_details']?['chandra_rasi'] ?? {};
    final soorya = json['nakshatra_details']?['soorya_rasi'] ?? {};
    final zodiac = json['nakshatra_details']?['zodiac'] ?? {};

    return BirthDetailsResult(
      nakshatra: _safeString(nak['name']),
      nakshatraPada: (nak['pada'] ?? 0).toInt(),
      chandraRasi: _safeString(chandra['name']),
      sooryaRasi: _safeString(soorya['name']),
      zodiac: _safeString(zodiac['name']),
    );
  }
}

// ── Mangal Dosha ───────────────────────────────────────────────

class MangalDoshaResult {
  final bool isManglik;
  final String description;
  final List<String> remedies;

  const MangalDoshaResult({
    required this.isManglik,
    required this.description,
    required this.remedies,
  });

  factory MangalDoshaResult.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] as Map<String, dynamic>?) ?? j;
    return MangalDoshaResult(
      isManglik: data['is_manglik'] == true || data['mangal_dosha'] == true,
      description: _safeString(data['description']),
      remedies: (data['remedies'] as List? ?? [])
          .map((r) => _safeString(r))
          .toList(),
    );
  }
}

// ── Kaal Sarp Dosha ────────────────────────────────────────────

class KaalSarpResult {
  final bool hasDosha;
  final String doshaType;
  final String description;

  const KaalSarpResult({
    required this.hasDosha,
    required this.doshaType,
    required this.description,
  });

  factory KaalSarpResult.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] as Map<String, dynamic>?) ?? j;

    String doshaType = "None";
    final type = data['type'];
    final dosha = data['dosha_type'];

    if (type is Map) {
      doshaType = _safeString(type['name']);
    } else if (type is String) {
      doshaType = type;
    } else if (dosha is Map) {
      doshaType = _safeString(dosha['name']);
    } else if (dosha is String) {
      doshaType = dosha;
    }

    return KaalSarpResult(
      hasDosha: data['has_dosha'] == true,
      doshaType: doshaType,
      description: _safeString(data['description']),
    );
  }
}

// ── Yoga Details ───────────────────────────────────────────────

class YogaInfo {
  final String name;
  final bool hasYoga;
  final String description;

  const YogaInfo({
    required this.name,
    required this.hasYoga,
    required this.description,
  });

  factory YogaInfo.fromJson(Map<String, dynamic> j) => YogaInfo(
    name: _safeString(j['name']),
    hasYoga: j['has_yoga'] == true,
    description: _safeString(j['description']),
  );
}

class YogaResult {
  final List<YogaInfo> majorYogas;
  final List<YogaInfo> chandraYogas;
  final List<YogaInfo> sooryaYogas;
  final List<YogaInfo> inauspiciousYogas;

  const YogaResult({
    required this.majorYogas,
    required this.chandraYogas,
    required this.sooryaYogas,
    required this.inauspiciousYogas,
  });

  List<YogaInfo> get presentMajorYogas =>
      majorYogas.where((y) => y.hasYoga).toList();

  factory YogaResult.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] as Map<String, dynamic>?) ?? j;

    List<YogaInfo> parse(String key) => (data[key] as List? ?? [])
        .map((y) => YogaInfo.fromJson(y as Map<String, dynamic>))
        .toList();

    return YogaResult(
      majorYogas: parse('yoga_list'),
      chandraYogas: parse('chandra_yoga_list'),
      sooryaYogas: parse('soorya_yoga_list'),
      inauspiciousYogas: parse('inauspicious_yoga_list'),
    );
  }
}

// ── Vimsottari Dasha ───────────────────────────────────────────

class MahaDasha {
  final String lord;
  final DateTime start;
  final DateTime end;
  final List<AntarDasha> antarDashas;

  const MahaDasha({
    required this.lord,
    required this.start,
    required this.end,
    this.antarDashas = const [],
  });

  bool get isCurrentlyActive =>
      DateTime.now().isAfter(start) && DateTime.now().isBefore(end);

  factory MahaDasha.fromJson(Map<String, dynamic> j) => MahaDasha(
    lord: _safeString(j['name']),
    start: DateTime.tryParse(j['start'] ?? '') ?? DateTime(1970),
    end: DateTime.tryParse(j['end'] ?? '') ?? DateTime(1970),
    antarDashas: (j['antardasha'] as List? ?? [])
        .map((a) => AntarDasha.fromJson(a as Map<String, dynamic>))
        .toList(),
  );
}

class AntarDasha {
  final String lord;
  final DateTime start;
  final DateTime end;

  const AntarDasha({
    required this.lord,
    required this.start,
    required this.end,
  });

  factory AntarDasha.fromJson(Map<String, dynamic> j) => AntarDasha(
    lord: _safeString(j['name']),
    start: DateTime.tryParse(j['start'] ?? '') ?? DateTime(1970),
    end: DateTime.tryParse(j['end'] ?? '') ?? DateTime(1970),
  );
}

// ✅ FIXED: dashaBalance now safely extracted from Map or String
class DashaResult {
  final String dashaBalance;
  final List<MahaDasha> mahadashas;

  const DashaResult({
    required this.dashaBalance,
    required this.mahadashas,
  });

  MahaDasha? get currentMahaDasha =>
      mahadashas.where((d) => d.isCurrentlyActive).firstOrNull;

  factory DashaResult.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] as Map<String, dynamic>?) ?? j;

    String dashaBalanceStr = '';
    final dashaBalanceRaw = data['dasha_balance'];
    if (dashaBalanceRaw is Map) {
      dashaBalanceStr = _safeString(dashaBalanceRaw['name']);
    } else if (dashaBalanceRaw is String) {
      dashaBalanceStr = dashaBalanceRaw;
    }

    return DashaResult(
      dashaBalance: dashaBalanceStr,
      mahadashas: (data['dasha_periods'] as List? ?? [])
          .map((d) => MahaDasha.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── Sade Sati ──────────────────────────────────────────────────

class SadeSatiTransit {
  final String period;
  final String sign;
  final String phase;

  const SadeSatiTransit({
    required this.period,
    required this.sign,
    required this.phase,
  });

  factory SadeSatiTransit.fromJson(Map<String, dynamic> j) => SadeSatiTransit(
    period: _safeString(j['period']),
    sign: _safeString(j['sign']?['name'] ?? j['sign']),
    phase: _safeString(j['transit_phase'] ?? j['phase']),
  );
}

class SadeSatiResult {
  final bool isCurrentlyInSadeSati;
  final String transitPhase;
  final String description;

  SadeSatiResult({
    required this.isCurrentlyInSadeSati,
    required this.transitPhase,
    required this.description,
  });

  factory SadeSatiResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SadeSatiResult(
      isCurrentlyInSadeSati: data['is_in_sade_sati'] ?? false,
      transitPhase: _safeString(data['transit_phase']),
      description: _safeString(data['description']),
    );
  }
}

// ── Aggregated Report ──────────────────────────────────────────

class BirthChartReport {
  final String name;
  final DateTime dateTime;
  final String placeOfBirth;

  final BirthDetailsResult birthDetails;
  final List<Planet> planets;
  final Planet? ascendant;

  final MangalDoshaResult mangalDosha;
  final KaalSarpResult kaalSarp;
  final YogaResult yogaDetails;
  final DashaResult dasha;
  final SadeSatiResult sadeSati;

  BirthChartReport({
    required this.name,
    required this.dateTime,
    required this.placeOfBirth,
    required this.birthDetails,
    required this.planets,
    required this.ascendant,
    required this.mangalDosha,
    required this.kaalSarp,
    required this.yogaDetails,
    required this.dasha,
    required this.sadeSati,
  });

  factory BirthChartReport.fromJson(Map<String, dynamic> json) {
    final planetData = json['planet_position'] ?? {};

    final planetList = (planetData['planet_position'] as List? ?? [])
        .map((e) => Planet.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    Planet? asc;
    try {
      if (planetData['ascendant'] != null) {
        asc = Planet.fromJson(
          Map<String, dynamic>.from(planetData['ascendant']),
        );
      }
    } catch (_) {}

    return BirthChartReport(
      name: _safeString(json['name']),
      dateTime: DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now(),
      placeOfBirth: _safeString(json['place_of_birth']),
      birthDetails: BirthDetailsResult.fromJson(
        Map<String, dynamic>.from(json['birth_details'] ?? {}),
      ),
      planets: planetList,
      ascendant: asc,
      mangalDosha: MangalDoshaResult.fromJson(
        Map<String, dynamic>.from(json['mangal_dosha'] ?? {}),
      ),
      kaalSarp: KaalSarpResult.fromJson(
        Map<String, dynamic>.from(json['kaal_sarp'] ?? {}),
      ),
      yogaDetails: YogaResult.fromJson(
        Map<String, dynamic>.from(json['yoga_details'] ?? {}),
      ),
      dasha: DashaResult.fromJson(
        Map<String, dynamic>.from(json['dasha'] ?? {}),
      ),
      sadeSati: SadeSatiResult.fromJson(
        Map<String, dynamic>.from(json['sade_sati'] ?? {}),
      ),
    );
  }
}