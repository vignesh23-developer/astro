// kundli_model.dart
class KundliModel {
  final bool success;
  final KundliData? data;

  KundliModel({
    required this.success,
    this.data,
  });

  factory KundliModel.fromJson(Map<String, dynamic> json) {
    return KundliModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? KundliData.fromJson(json['data']) : null,
    );
  }
}

class KundliData {
  final KundliDetails? kundli;
  final PlanetData? planet;
  final MangalDosha? mangal;
  final SadeSati? sadeSati;
  final DashaData? dasha;

  KundliData({
    this.kundli,
    this.planet,
    this.mangal,
    this.sadeSati,
    this.dasha,
  });

  factory KundliData.fromJson(Map<String, dynamic> json) {
    return KundliData(
      kundli: json['kundli'] != null ? KundliDetails.fromJson(json['kundli']) : null,
      planet: json['planet'] != null ? PlanetData.fromJson(json['planet']) : null,
      mangal: json['mangal'] != null ? MangalDosha.fromJson(json['mangal']) : null,
      sadeSati: json['sadeSati'] != null ? SadeSati.fromJson(json['sadeSati']) : null,
      dasha: json['dasha'] != null ? DashaData.fromJson(json['dasha']) : null,
    );
  }
}

class KundliDetails {
  final NakshatraDetails? nakshatraDetails;
  final MangalDosha? mangalDosha;
  final List<YogaDetails>? yogaDetails;

  KundliDetails({
    this.nakshatraDetails,
    this.mangalDosha,
    this.yogaDetails,
  });

  factory KundliDetails.fromJson(Map<String, dynamic> json) {
    return KundliDetails(
      nakshatraDetails: json['data']?['nakshatra_details'] != null
          ? NakshatraDetails.fromJson(json['data']['nakshatra_details'])
          : null,
      mangalDosha: json['data']?['mangal_dosha'] != null
          ? MangalDosha.fromJson(json['data']['mangal_dosha'])
          : null,
      yogaDetails: (json['data']?['yoga_details'] as List?)
          ?.map((e) => YogaDetails.fromJson(e))
          .toList(),
    );
  }
}

class NakshatraDetails {
  final Nakshatra? nakshatra;
  final Rasi? chandraRasi;
  final Rasi? sooryaRasi;
  final Zodiac? zodiac;
  final AdditionalInfo? additionalInfo;

  NakshatraDetails({
    this.nakshatra,
    this.chandraRasi,
    this.sooryaRasi,
    this.zodiac,
    this.additionalInfo,
  });

  factory NakshatraDetails.fromJson(Map<String, dynamic> json) {
    return NakshatraDetails(
      nakshatra: json['nakshatra'] != null ? Nakshatra.fromJson(json['nakshatra']) : null,
      chandraRasi: json['chandra_rasi'] != null ? Rasi.fromJson(json['chandra_rasi']) : null,
      sooryaRasi: json['soorya_rasi'] != null ? Rasi.fromJson(json['soorya_rasi']) : null,
      zodiac: json['zodiac'] != null ? Zodiac.fromJson(json['zodiac']) : null,
      additionalInfo: json['additional_info'] != null ? AdditionalInfo.fromJson(json['additional_info']) : null,
    );
  }
}

class Nakshatra {
  final int id;
  final String name;
  final Lord? lord;
  final int pada;

  Nakshatra({
    required this.id,
    required this.name,
    this.lord,
    required this.pada,
  });

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    return Nakshatra(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lord: json['lord'] != null ? Lord.fromJson(json['lord']) : null,
      pada: json['pada'] ?? 0,
    );
  }
}

class Rasi {
  final int id;
  final String name;
  final Lord? lord;

  Rasi({
    required this.id,
    required this.name,
    this.lord,
  });

  factory Rasi.fromJson(Map<String, dynamic> json) {
    return Rasi(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lord: json['lord'] != null ? Lord.fromJson(json['lord']) : null,
    );
  }
}

class Lord {
  final int id;
  final String name;
  final String vedicName;

  Lord({
    required this.id,
    required this.name,
    required this.vedicName,
  });

  factory Lord.fromJson(Map<String, dynamic> json) {
    return Lord(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      vedicName: json['vedic_name'] ?? '',
    );
  }
}

class Zodiac {
  final int id;
  final String name;

  Zodiac({
    required this.id,
    required this.name,
  });

  factory Zodiac.fromJson(Map<String, dynamic> json) {
    return Zodiac(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class AdditionalInfo {
  final String deity;
  final String ganam;
  final String symbol;
  final String animalSign;
  final String nadi;
  final String color;
  final String bestDirection;
  final String syllables;
  final String birthStone;
  final String gender;
  final String planet;
  final String enemyYoni;

  AdditionalInfo({
    required this.deity,
    required this.ganam,
    required this.symbol,
    required this.animalSign,
    required this.nadi,
    required this.color,
    required this.bestDirection,
    required this.syllables,
    required this.birthStone,
    required this.gender,
    required this.planet,
    required this.enemyYoni,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      deity: json['deity'] ?? '',
      ganam: json['ganam'] ?? '',
      symbol: json['symbol'] ?? '',
      animalSign: json['animal_sign'] ?? '',
      nadi: json['nadi'] ?? '',
      color: json['color'] ?? '',
      bestDirection: json['best_direction'] ?? '',
      syllables: json['syllables'] ?? '',
      birthStone: json['birth_stone'] ?? '',
      gender: json['gender'] ?? '',
      planet: json['planet'] ?? '',
      enemyYoni: json['enemy_yoni'] ?? '',
    );
  }
}

class MangalDosha {
  final bool hasDosha;
  final String description;

  MangalDosha({
    required this.hasDosha,
    required this.description,
  });

  factory MangalDosha.fromJson(Map<String, dynamic> json) {
    return MangalDosha(
      hasDosha: json['has_dosha'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class YogaDetails {
  final String name;
  final String description;

  YogaDetails({
    required this.name,
    required this.description,
  });

  factory YogaDetails.fromJson(Map<String, dynamic> json) {
    return YogaDetails(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class PlanetData {
  final List<PlanetPosition>? planetPosition;

  PlanetData({
    this.planetPosition,
  });

  factory PlanetData.fromJson(Map<String, dynamic> json) {
    return PlanetData(
      planetPosition: (json['data']?['planet_position'] as List?)
          ?.map((e) => PlanetPosition.fromJson(e))
          .toList(),
    );
  }
}

class PlanetPosition {
  final int id;
  final String name;
  final double longitude;
  final bool isRetrograde;
  final int position;
  final double degree;
  final Rasi? rasi;

  PlanetPosition({
    required this.id,
    required this.name,
    required this.longitude,
    required this.isRetrograde,
    required this.position,
    required this.degree,
    this.rasi,
  });

  factory PlanetPosition.fromJson(Map<String, dynamic> json) {
    return PlanetPosition(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      longitude: (json['longitude'] ?? 0).toDouble(),
      isRetrograde: json['is_retrograde'] ?? false,
      position: json['position'] ?? 0,
      degree: (json['degree'] ?? 0).toDouble(),
      rasi: json['rasi'] != null ? Rasi.fromJson(json['rasi']) : null,
    );
  }
}

class SadeSati {
  final bool isInSadeSati;
  final String? transitPhase;
  final String description;

  SadeSati({
    required this.isInSadeSati,
    this.transitPhase,
    required this.description,
  });

  factory SadeSati.fromJson(Map<String, dynamic> json) {
    return SadeSati(
      isInSadeSati: json['data']?['is_in_sade_sati'] ?? false,
      transitPhase: json['data']?['transit_phase'],
      description: json['data']?['description'] ?? '',
    );
  }
}

class DashaData {
  final List<DashaPeriod>? dashaPeriods;
  final DashaBalance? dashaBalance;

  DashaData({
    this.dashaPeriods,
    this.dashaBalance,
  });

  factory DashaData.fromJson(Map<String, dynamic> json) {
    return DashaData(
      dashaPeriods: (json['data']?['dasha_periods'] as List?)
          ?.map((e) => DashaPeriod.fromJson(e))
          .toList(),
      dashaBalance: json['data']?['dasha_balance'] != null
          ? DashaBalance.fromJson(json['data']['dasha_balance'])
          : null,
    );
  }
}

class DashaPeriod {
  final int id;
  final String name;
  final String start;
  final String end;
  final List<Antardasha>? antardasha;

  DashaPeriod({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    this.antardasha,
  });

  factory DashaPeriod.fromJson(Map<String, dynamic> json) {
    return DashaPeriod(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      antardasha: (json['antardasha'] as List?)
          ?.map((e) => Antardasha.fromJson(e))
          .toList(),
    );
  }
}

class Antardasha {
  final int id;
  final String name;
  final String start;
  final String end;
  final List<Pratyantardasha>? pratyantardasha;

  Antardasha({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    this.pratyantardasha,
  });

  factory Antardasha.fromJson(Map<String, dynamic> json) {
    return Antardasha(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      pratyantardasha: (json['pratyantardasha'] as List?)
          ?.map((e) => Pratyantardasha.fromJson(e))
          .toList(),
    );
  }
}

class Pratyantardasha {
  final int id;
  final String name;
  final String start;
  final String end;

  Pratyantardasha({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  factory Pratyantardasha.fromJson(Map<String, dynamic> json) {
    return Pratyantardasha(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }
}

class DashaBalance {
  final Lord? lord;
  final String duration;
  final String description;

  DashaBalance({
    this.lord,
    required this.duration,
    required this.description,
  });

  factory DashaBalance.fromJson(Map<String, dynamic> json) {
    return DashaBalance(
      lord: json['lord'] != null ? Lord.fromJson(json['lord']) : null,
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }
}