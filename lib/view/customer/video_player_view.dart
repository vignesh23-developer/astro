import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoPlayerView extends StatefulWidget {
  final List<String> urls;
  final int startIndex;
  final Function()? onCompleted;

  const VideoPlayerView({
    super.key,
    required this.urls,
    required this.startIndex,
    this.onCompleted,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  bool hasShownAdvanceDialog = false;
  late BetterPlayerController _controller;
  late int currentIndex;
  bool hasShownLastFiveSecDialog = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    currentIndex = widget.startIndex;
    _initializePlayer(widget.urls[currentIndex]);
  }

  void _initializePlayer(String url) {
  final dataSource = BetterPlayerDataSource(
    BetterPlayerDataSourceType.network,
    url,
  );

  _controller = BetterPlayerController(
    BetterPlayerConfiguration(
      autoPlay: true,
      looping: false,
      fit: BoxFit.cover,
      fullScreenByDefault: false,
      handleLifecycle: true,
      autoDetectFullscreenAspectRatio: false,
      expandToFill: false,

      eventListener: (event) {
        if (event.betterPlayerEventType ==
            BetterPlayerEventType.progress) {

          final progress = event.parameters?['progress'];
          final duration = event.parameters?['duration'];

          if (progress != null && duration != null) {
            final remaining =
                duration.inSeconds - progress.inSeconds;

            if (remaining <= 5 &&
                !hasShownLastFiveSecDialog) {

              hasShownLastFiveSecDialog = true;

              debugPrint("🔥 Last 5 seconds reached");

              widget.onCompleted?.call();
            }
          }
        }

        if (event.betterPlayerEventType ==
            BetterPlayerEventType.finished) {

          if (currentIndex == widget.urls.length - 1) {
            widget.onCompleted?.call();
          }

          _playNext();
        }
      },
    ),
    betterPlayerDataSource: dataSource,
  );
}

  void _playNext() async {
    if (currentIndex < widget.urls.length - 1) {
      currentIndex++;
      hasShownAdvanceDialog = false;
      hasShownLastFiveSecDialog = false;

      await _controller.pause();

      _controller.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.urls[currentIndex],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BetterPlayer(controller: _controller),
          ),
        ),
      ),
    );
  }
}

