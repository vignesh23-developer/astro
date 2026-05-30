import 'package:asrology/view/customer/astro_pages/pdf_service.dart';
import 'package:asrology/view/customer/astro_pages/planet_table.dart';
import 'package:asrology/view/customer/astro_pages/section_card.dart';
import 'package:asrology/view/customer/astro_pages/yoga_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../api_services/prokerala_api_service.dart';
import '../../../model/birth_chart_models.dart';
import 'dasha_timeline.dart';
import 'dosha_badge.dart';
import 'package:asrology/view/customer/astro_pages/planet_table.dart';
import 'package:asrology/view/customer/astro_pages/section_card.dart';
import 'package:asrology/view/customer/astro_pages/yoga_grid.dart';
import 'package:flutter/material.dart';
import '../../../api_services/prokerala_api_service.dart';
import '../../../model/birth_chart_models.dart';
import 'dasha_timeline.dart';
import 'dosha_badge.dart';
import 'kundli_chart.dart';

class BirthChartScreen extends StatefulWidget {
  final String name;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String placeOfBirth;
  final String gender;

  const BirthChartScreen({
    super.key,
    required this.name,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.placeOfBirth,
    required this.gender,
  });

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  late final ProkeralaApiService _api;

  BirthChartReport? _report;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _api = ProkeralaApiService(
      // clientId: '0b7e59b5-d839-41e8-bf6c-5026b12e7ba1',
      // clientSecret: 'j180JC9eAJ1EuoHU43hLKvAQKJdR3fWIgG5vvjr3',
      clientId: '13534389-ced3-4bdd-b2fa-e42b5aa7f79f',
      clientSecret: 'lfHI76p16XriWb5dyWbslPyfcKIFLgMjeQ6M7y4F',
    );

    _fetchReport();
  }

  Future<void> _fetchReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      /// API now returns Map<String,dynamic>
      final data = await _api.getFullBirthChartReport(
        name: widget.name,
        latitude: widget.latitude,
        longitude: widget.longitude,
        dateTime: widget.dateTime,
        gender: widget.gender,
      );

      /// Convert Map → Model
      final report = BirthChartReport.fromJson(data);

      if (mounted) {
        setState(() {
          _report = report;
        });
      }
    } catch (e) {
      debugPrint("Birth Chart Fetch Error: $e");

      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F3),

      appBar: AppBar(
        title: Text(
          '${widget.name} — Birth Chart',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        backgroundColor: const Color(0xFFFBF8F3),
        foregroundColor: const Color(0xFF4A1E0C),
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              if (_report != null) {
                PdfService.generate(_report!);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchReport,
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const _LoadingView();
    }

    if (_error != null) {
      return _ErrorView(error: _error!, onRetry: _fetchReport);
    }

    if (_report == null) {
      return const SizedBox.shrink();
    }

    return _ReportView(report: _report!, name: widget.name);
  }
}

////////////////////////////////////////////////////////////////
/// LOADING VIEW
////////////////////////////////////////////////////////////////

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50.h,
            width: 50.w,
            child: Lottie.asset('assets/ALogo/loading.json', fit: BoxFit.cover),
          ),
          SizedBox(height: 16),

          Text(
            "Calculating birth chart...",
            style: TextStyle(fontSize: 15, color: Color(0xFF6B4C3B)),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// ERROR VIEW
////////////////////////////////////////////////////////////////

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF8B3A2E)),

            const SizedBox(height: 12),

            const Text(
              "Failed to load birth chart",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A1E0C),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B4C3B)),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B3A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// REPORT VIEW
////////////////////////////////////////////////////////////////

class _ReportView extends StatelessWidget {
  final BirthChartReport report;
  final String name;

  const _ReportView({required this.report, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        _CoverCard(report: report, name: name),
        const SizedBox(height: 12),

        SectionCard(
          title: "Birth Details",
          icon: Icons.auto_awesome,
          child: _BirthDetailsGrid(details: report.birthDetails),
        ),
        const SizedBox(height: 12),

        SectionCard(
          title: "Planet Positions",
          icon: Icons.public,
          child: PlanetTable(
            result: PlanetPositionResult(
              planets: report.planets,
              ascendant: report.ascendant,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: DoshaBadge(
                title: "Mangal Dosha",
                hasDosha: report.mangalDosha.isManglik,
                presentLabel: "Manglik",
                absentLabel: "Not Manglik",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DoshaBadge(
                title: "Kaal Sarp",
                hasDosha: report.kaalSarp.hasDosha,
                presentLabel: report.kaalSarp.doshaType,
                absentLabel: "Not Present",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SectionCard(
          title: "Yoga Details",
          icon: Icons.star,
          child: YogaGrid(yogaResult: report.yogaDetails),
        ),
        const SizedBox(height: 12),

        SectionCard(
          title: "Vimsottari Dasha",
          icon: Icons.timeline,
          child: DashaTimelineGraph(dasha: report.dasha),
        ),
        const SizedBox(height: 12),

        SectionCard(
          title: "Sade Sati",
          icon: Icons.brightness_3,
          child: _SadeSatiSection(sadeSati: report.sadeSati),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: "Kundli Chart",
          icon: Icons.grid_view,
          child: KundliChart(planets: report.planets),
        ),
      ],
    );
  }
}

class _CoverCard extends StatelessWidget {
  final BirthChartReport report;
  final String name;
  const _CoverCard({required this.report, required this.name});

  String _formatDate(DateTime dt) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${dt.day} ${months[dt.month]}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B3A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Text(
                _formatDate(report.dateTime),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Text(
                _formatTime(report.dateTime),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          if (report.placeOfBirth.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.place, color: Colors.white70, size: 14),
                const SizedBox(width: 6),
                Text(
                  report.placeOfBirth,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          // Key indicators chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip('☾ ${report.birthDetails.chandraRasi}'),
              _chip('☀ ${report.birthDetails.sooryaRasi}'),
              _chip('↑ ${report.birthDetails.zodiac}'),
              _chip('✦ ${report.birthDetails.nakshatra}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.18),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}

// ── Birth Details Grid ───────────────────────────────────────────────────────

class _BirthDetailsGrid extends StatelessWidget {
  final BirthDetailsResult details;

  const _BirthDetailsGrid({required this.details});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Nakshatra', '${details.nakshatra} (${details.nakshatraPada})'),
      ('Chandra Rasi', details.chandraRasi),
      ('Soorya Rasi', details.sooryaRasi),
      ('Zodiac', details.zodiac),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return _DetailRow(label: item.$1, value: item.$2);
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8B6650),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C1A0E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sade Sati Section ────────────────────────────────────────────────────────

class _SadeSatiSection extends StatelessWidget {
  final SadeSatiResult sadeSati;
  const _SadeSatiSection({required this.sadeSati});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: sadeSati.isCurrentlyInSadeSati
                ? const Color(0xFFFFF3CD)
                : const Color(0xFFD4EDDA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                sadeSati.isCurrentlyInSadeSati
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                color: sadeSati.isCurrentlyInSadeSati
                    ? const Color(0xFF856404)
                    : const Color(0xFF155724),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sadeSati.isCurrentlyInSadeSati
                      ? 'Currently in Sade Sati phase'
                      : 'Not in Sade Sati phase currently',
                  style: TextStyle(
                    color: sadeSati.isCurrentlyInSadeSati
                        ? const Color(0xFF856404)
                        : const Color(0xFF155724),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (sadeSati.transitPhase.isNotEmpty) ...[
          const SizedBox(height: 12),

          const Text(
            'Sade Sati Phase',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B4C3B),
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6EDE6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_graph,
                  size: 16,
                  color: Color(0xFF8B3A2E),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    sadeSati.transitPhase,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A1E0C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
