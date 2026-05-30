import 'package:flutter/material.dart';
import '../../../model/birth_chart_models.dart';

class KundliChart extends StatelessWidget {
  final List<Planet> planets;

  const KundliChart({super.key, required this.planets});

  Map<int, List<String>> _groupByHouse() {
    final map = <int, List<String>>{};

    for (var p in planets) {
      map.putIfAbsent(p.position, () => []).add(p.name);
    }

    return map;
  }

  Widget _box(int house, Map<int, List<String>> data) {
    final items = data[house] ?? [];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$house",
                style: const TextStyle(fontSize: 10, color: Colors.black)),
            ...items.map((e) => Text(
              e,
              style: const TextStyle(fontSize: 11,color: Colors.black),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _groupByHouse();

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.count(
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _box(1, data),
          _box(2, data),
          _box(3, data),
          _box(4, data),
          _box(5, data),
          _box(6, data),
          _box(7, data),
          _box(8, data),
          _box(9, data),
          _box(10, data),
          _box(11, data),
          _box(12, data),
          // _box(0, data),
          // _box(0, data),
        ],
      ),
    );
  }
}