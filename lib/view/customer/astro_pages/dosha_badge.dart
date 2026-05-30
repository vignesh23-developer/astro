import 'package:flutter/material.dart';

class DoshaBadge extends StatelessWidget {
  final String title;
  final bool hasDosha;
  final String presentLabel;
  final String absentLabel;

  const DoshaBadge({
    super.key,
    required this.title,
    required this.hasDosha,
    required this.presentLabel,
    required this.absentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = hasDosha
        ? const Color(0xFFFFF3CD)
        : const Color(0xFFD4EDDA);
    final textColor = hasDosha
        ? const Color(0xFF856404)
        : const Color(0xFF155724);
    final borderColor = hasDosha
        ? const Color(0xFFFFE083)
        : const Color(0xFF9FD3AB);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B4C3B),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                hasDosha
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                size: 16,
                color: textColor,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  hasDosha ? presentLabel : absentLabel,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
