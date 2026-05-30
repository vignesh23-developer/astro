import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class VideoFullScreenPage extends StatefulWidget {
  final String videoUrl;
  const VideoFullScreenPage({super.key, required this.videoUrl});

  @override
  State<VideoFullScreenPage> createState() => _VideoFullScreenPageState();
}

class _VideoFullScreenPageState extends State<VideoFullScreenPage> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        fit: BoxFit.cover,
        fullScreenByDefault: false,
        handleLifecycle: true,
        autoDetectFullscreenAspectRatio: false,
        expandToFill: false,
      ),
    )..setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BetterPlayer(controller: _betterPlayerController),
      ),
    );
  }
}