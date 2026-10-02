import 'package:animate_do/animate_do.dart';
import 'package:e201_toktik/config/helpers/human_formats.dart';
import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

class VideoButtons extends StatelessWidget {
  final VideoPost video;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const VideoButtons({
    super.key,
    required this.video,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomIconButton(
          value: video.likes,
          icon: Icons.favorite,
          iconColor: video.isLiked ? Colors.red : Colors.white,
          onPressed: onLike,
        ),
        SizedBox(height: 20),
        _CustomIconButton(
          value: video.views,
          icon: Icons.remove_red_eye_outlined,
          onPressed: null,
        ),
        SizedBox(height: 20),
        _CustomIconButton(
          value: video.comments.length,
          icon: Icons.mode_comment_outlined,
          onPressed: onComment,
        ),
        SizedBox(height: 20),
        SpinPerfect(
          infinite: true,
          duration: Duration(seconds: 5),
          child: _CustomIconButton(
            value: 0,
            icon: Icons.play_circle_outline,
            onPressed: null,
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.value,
    required this.icon,
    required this.onPressed,
    iconColor,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: 30),
        ),
        if (value > 0) Text(HumanFormats.humanReadableNumber(value.toDouble())),
      ],
    );
  }
}
