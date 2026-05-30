import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/birth_chart_models.dart';

class DashaTimelineGraph extends StatefulWidget {
  final DashaResult dasha;

  const DashaTimelineGraph({super.key, required this.dasha});

  @override
  State<DashaTimelineGraph> createState() => _DashaTimelineGraphState();
}

class _DashaTimelineGraphState extends State<DashaTimelineGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🎨 Planet Colors (Premium)
  Color _planetColor(String planet) {
    switch (planet.toLowerCase()) {
      case 'saturn':
        return const Color(0xFF4A6CF7);
      case 'mars':
        return const Color(0xFFFF4D4D);
      case 'jupiter':
        return const Color(0xFFFFA726);
      case 'venus':
        return const Color(0xFFFF6EC7);
      case 'mercury':
        return const Color(0xFF00C853);
      case 'moon':
        return const Color(0xFFB0BEC5);
      case 'sun':
        return const Color(0xFFFFD54F);
      default:
        return const Color(0xFF8D6E63);
    }
  }

  /// 🧠 Smart Meaning
  String _planetInsight(String planet) {
    switch (planet.toLowerCase()) {
      case 'saturn':
        return "Hard work phase. Slow success but long-term gains.";
      case 'mars':
        return "High energy. Be careful with anger & decisions.";
      case 'jupiter':
        return "Best phase for growth, luck and success.";
      case 'venus':
        return "Love, luxury & relationships improve.";
      case 'mercury':
        return "Career, business & communication peak.";
      case 'moon':
        return "Emotional phase. Focus on mental balance.";
      case 'sun':
        return "Power, authority and leadership rise.";
      default:
        return "";
    }
  }

  /// 📊 Good/Bad Score
  double _score(String planet) {
    switch (planet.toLowerCase()) {
      case 'jupiter':
      case 'venus':
        return 0.9;
      case 'sun':
      case 'mercury':
        return 0.7;
      case 'moon':
        return 0.5;
      case 'mars':
        return 0.4;
      case 'saturn':
        return 0.3;
      default:
        return 0.5;
    }
  }

  bool _isCurrent(DateTime start, DateTime end) {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  /// 🔥 Premium Bottom Sheet
  void _showDetails(MahaDasha d) {
    final score = _score(d.lord);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.black.withOpacity(0.75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${d.lord} Mahadasha",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    _planetInsight(d.lord),
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  /// 📊 Score Meter
                  LinearProgressIndicator(
                    value: score,
                    minHeight: 6.h,
                    backgroundColor: Colors.white10,
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    "Life Score: ${(score * 100).toInt()}%",
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDays = widget.dasha.mahadashas.fold<int>(
      0,
          (sum, d) => sum + d.end.difference(d.start).inDays,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🌌 Cosmic Background Container
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SizedBox(
            height: 100.h,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.dasha.mahadashas.length,
                  itemBuilder: (context, index) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final d = widget.dasha.mahadashas[index];
                    final days = d.end.difference(d.start).inDays;
                    final widthFactor = days / totalDays;
                    final isCurrent = _isCurrent(d.start, d.end);
                    final calculatedWidth = (widthFactor * screenWidth * 1.8)
                        .clamp(60.w, 220.w);
                    return GestureDetector(
                      onTap: () => _showDetails(d),
                      child:GestureDetector(
                        onTap: () => _showDetails(d),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),

                          width: calculatedWidth * _controller.value,

                          margin: EdgeInsets.only(right: 10.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _planetColor(d.lord),
                                _planetColor(d.lord).withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: isCurrent
                                ? [
                              BoxShadow(
                                color: _planetColor(d.lord).withOpacity(0.8),
                                blurRadius: 12,
                              )
                            ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              d.lord,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    );
                  },
                );
              },
            ),
          ),
        ),

        SizedBox(height: 14.h),

        /// 🧠 Insight Card (Current Dasha)
        Builder(
          builder: (context) {
            final current = widget.dasha.mahadashas.firstWhere(
                  (d) => _isCurrent(d.start, d.end),
              orElse: () => widget.dasha.mahadashas.first,
            );

            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome,
                      color: _planetColor(current.lord)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _planetInsight(current.lord),
                      style: TextStyle(
                          color: Colors.white70, fontSize: 11.sp),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}


class _DashaProgressBar extends StatelessWidget {
  final MahaDasha dasha;
  const _DashaProgressBar({required this.dasha});

  @override
  Widget build(BuildContext context) {
    final total = dasha.end.difference(dasha.start).inDays;
    final elapsed = DateTime.now().difference(dasha.start).inDays;
    final progress = (elapsed / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.25),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(0)}% elapsed',
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class _DashaRow extends StatelessWidget {
  final String lord;
  final String start;
  final String end;
  final bool isCurrent;

  const _DashaRow({
    required this.lord,
    required this.start,
    required this.end,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFFFAEDE8)
            : const Color(0xFFFBF8F3),
        borderRadius: BorderRadius.circular(8),
        border: isCurrent
            ? Border.all(color: const Color(0xFF8B3A2E).withOpacity(0.5))
            : null,
      ),
      child: Row(
        children: [
          if (isCurrent)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.arrow_right_rounded,
                  size: 18, color: Color(0xFF8B3A2E)),
            ),
          Expanded(
            child: Text(
              '$lord Mahadasha',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isCurrent ? FontWeight.w700 : FontWeight.w500,
                color: isCurrent
                    ? const Color(0xFF8B3A2E)
                    : const Color(0xFF4A1E0C),
              ),
            ),
          ),
          Text(
            '$start — $end',
            style: TextStyle(
              fontSize: 12,
              color: isCurrent
                  ? const Color(0xFF8B3A2E)
                  : const Color(0xFF6B4C3B),
            ),
          ),
        ],
      ),
    );
  }
}
