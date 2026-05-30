import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/birth_chart_models.dart';

class PlanetTable extends StatelessWidget {
  final PlanetPositionResult result;

  const PlanetTable({super.key, required this.result});

  static const _planetSymbols = {
    'Sun': '☀',
    'Moon': '☾',
    'Mercury': '☿',
    'Venus': '♀',
    'Mars': '♂',
    'Jupiter': '♃',
    'Saturn': '♄',
    'Rahu': '☊',
    'Ketu': '☋',
    'Ascendant': '↑',
  };

  String _formatDegree(double d) {
    return "${d.toStringAsFixed(2)}°";
  }

  @override
  Widget build(BuildContext context) {
    final rows = <_PlanetRow>[];

    for (final p in result.planets) {
      rows.add(
        _PlanetRow(
          symbol: _planetSymbols[p.name] ?? '●',
          name: p.name,
          degree: _formatDegree(p.degree),
          rasi: p.rasi,
          rasiLord: p.rasiLord,
          bhava: p.position,
          isRetrograde: p.isRetrograde,
        ),
      );
    }

    if (result.ascendant != null) {
      final a = result.ascendant!;
      rows.add(
        _PlanetRow(
          symbol: '↑',
          name: 'Ascendant',
          degree: _formatDegree(a.degree),
          rasi: a.rasi,
          rasiLord: a.rasiLord,
          bhava: a.position,
          isRetrograde: false,
          isAscendant: true,
        ),
      );
    }

    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        ...rows.map((r) => _PlanetRowCard(row: r)).toList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEDE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Row(
        children: [
          SizedBox(width: 30),
          Expanded(flex: 3, child: Text('Planet',style: TextStyle(color: Colors.black,fontSize: 12.sp))),
          SizedBox(width: 40, child: Text('Bhava',style: TextStyle(color: Colors.black,fontSize: 12.sp),)),
          Expanded(flex: 2, child: Text('Rasi',style: TextStyle(color: Colors.black,fontSize: 12.sp),)),
          Expanded(flex: 2, child: Text('Lord',style: TextStyle(color: Colors.black,fontSize: 12.sp),)),
          Expanded(flex: 2, child: Text('Degree',style: TextStyle(color: Colors.black,fontSize: 12.sp),)),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// MODEL
////////////////////////////////////////////////////////////////

class _PlanetRow {
  final String symbol;
  final String name;
  final String degree;
  final String rasi;
  final String rasiLord;
  final int bhava;
  final bool isRetrograde;
  final bool isAscendant;

  const _PlanetRow({
    required this.symbol,
    required this.name,
    required this.degree,
    required this.rasi,
    required this.rasiLord,
    required this.bhava,
    required this.isRetrograde,
    this.isAscendant = false,
  });
}

////////////////////////////////////////////////////////////////
/// ROW CARD (PDF STYLE)
////////////////////////////////////////////////////////////////

class _PlanetRowCard extends StatelessWidget {
  final _PlanetRow row;

  const _PlanetRowCard({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: row.isAscendant
            ? const Color(0xFFFFF3CD)
            : const Color(0xFFFBF8F3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6D3C5)),
      ),
      child: Row(
        children: [
          /// SYMBOL
          SizedBox(
            width: 30,
            child: Text(
              row.symbol,
              style: TextStyle(
                fontSize: 18,
                color: row.isAscendant
                    ? const Color(0xFF4A1E0C)
                    : const Color(0xFF8B3A2E),
              ),
            ),
          ),

          /// PLANET NAME + RETRO
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  row.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    row.isAscendant ? FontWeight.w700 : FontWeight.w600,
                    color: const Color(0xFF2C1A0E),
                  ),
                ),
                if (row.isRetrograde) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B3A2E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'R',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// BHAVA
          SizedBox(
            width: 40,
            child: Text(
              row.bhava > 0 ? "${row.bhava}" : "-",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A1E0C),
              ),
            ),
          ),

          /// RASI
          Expanded(
            flex: 2,
            child: Text(
              row.rasi,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4A1E0C),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// LORD
          Expanded(
            flex: 2,
            child: Text(
              row.rasiLord,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B4C3B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// DEGREE
          Expanded(
            flex: 2,
            child: Text(
              row.degree,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B3A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}