import 'package:flutter/material.dart';

class Topic {
  final String title;
  final String description;
  final int lessons;
  final String videoUrl;
  final LinearGradient gradient;

  Topic({
    required this.title,
    required this.description,
    required this.lessons,
    required this.videoUrl,
    required this.gradient,
  });
}

