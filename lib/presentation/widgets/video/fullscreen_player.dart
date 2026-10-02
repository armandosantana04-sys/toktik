import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final bool isActive;

  const FullscreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    this.isActive = true,
  });

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;
  int _controllerGeneration = 0;
  Timer? _iconTimer;
  bool _showPlaybackIcon = false;
  IconData _playbackIcon = Icons.pause;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _activate();
  }

  @override
  void didUpdateWidget(covariant FullscreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive == widget.isActive) return;

    if (widget.isActive) {
      _activate();
    } else {
      _deactivate();
    }
  }

  void _activate() {
    final controller = VideoPlayerController.asset(widget.videoUrl);
    final generation = ++_controllerGeneration;
    _controller = controller;
    _initialization = controller.initialize().then((_) async {
      if (!_isCurrent(controller, generation)) return;
      await controller.setVolume(1.0);
      await controller.setLooping(true);
      if (_isCurrent(controller, generation)) await controller.play();
    });
  }

  bool _isCurrent(VideoPlayerController controller, int generation) =>
      mounted &&
      widget.isActive &&
      identical(_controller, controller) &&
      _controllerGeneration == generation;

  void _togglePlayback(VideoPlayerController controller) {
    final isPlaying = controller.value.isPlaying;

    setState(() {
      _playbackIcon = isPlaying ? Icons.pause : Icons.play_arrow;
      _showPlaybackIcon = true;
    });

    if (isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    _iconTimer?.cancel();
    _iconTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showPlaybackIcon = false);
    });
  }

  void _deactivate() {
    _iconTimer?.cancel();
    _controllerGeneration++;
    final controller = _controller;
    _controller = null;
    _initialization = null;
    controller?.dispose();
  }

  @override
  void dispose() {
    _iconTimer?.cancel();
    _controllerGeneration++;
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final initialization = _initialization;
    if (!widget.isActive || controller == null || initialization == null) {
      return const ColoredBox(color: Colors.black);
    }

    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (snapshot.hasError) {
          return const Center(child: Icon(Icons.error_outline));
        }

        return GestureDetector(
          onTap: () => _togglePlayback(controller),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller),
                IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showPlaybackIcon ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0x66000000),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _playbackIcon,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ),
                ),

                // Gradiente

                // Texto
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: _VideoCaption(caption: widget.caption),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(caption, maxLines: 2, style: titleStyle),
    );
  }
}