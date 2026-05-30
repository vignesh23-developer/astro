// yoga_grid.dart
import 'package:flutter/material.dart';

import '../../../model/birth_chart_models.dart';

class YogaGrid extends StatelessWidget {
  final YogaResult yogaResult;
  const YogaGrid({super.key, required this.yogaResult});

  @override
  Widget build(BuildContext context) {
    final present = yogaResult.presentMajorYogas;
    final sooryaPresent =
        yogaResult.sooryaYogas.where((y) => y.hasYoga).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (present.isNotEmpty) ...[
          _SectionLabel(
              label: 'Major Yogas (${present.length} present)'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: present.map((y) => _YogaChip(yoga: y)).toList(),
          ),
          const SizedBox(height: 14),
        ],
        if (sooryaPresent.isNotEmpty) ...[
          _SectionLabel(
              label: 'Soorya Yogas (${sooryaPresent.length} present)'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sooryaPresent.map((y) => _YogaChip(yoga: y)).toList(),
          ),
        ],
        // Full table with checkmarks
        const SizedBox(height: 14),
        _SectionLabel(label: 'All Major Yogas'),
        const SizedBox(height: 8),
        ...yogaResult.majorYogas.map((y) => _YogaRow(yoga: y)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8B3A2E),
          letterSpacing: 0.3,
        ),
      );
}

class _YogaChip extends StatelessWidget {
  final YogaInfo yoga;
  const _YogaChip({required this.yoga});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEDE8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B3A2E).withOpacity(0.4)),
      ),
      child: Text(
        yoga.name,
        style: const TextStyle(
          color: Color(0xFF8B3A2E),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _YogaRow extends StatelessWidget {
  final YogaInfo yoga;
  const _YogaRow({required this.yoga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            yoga.hasYoga ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: yoga.hasYoga
                ? const Color(0xFF2E8B57)
                : const Color(0xFFCCCCCC),
          ),
          const SizedBox(width: 8),
          Text(
            yoga.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: yoga.hasYoga ? FontWeight.w600 : FontWeight.w400,
              color: yoga.hasYoga
                  ? const Color(0xFF2C1A0E)
                  : const Color(0xFFAA9990),
            ),
          ),
        ],
      ),
    );
  }
}
