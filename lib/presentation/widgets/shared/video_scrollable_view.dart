import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:e201_toktik/presentation/widgets/video/fullscreen_player.dart';
import 'package:flutter/material.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;
  final ValueChanged<VideoPost> onViewed;
  final ValueChanged<VideoPost> onLike;
  final ValueChanged<VideoPost> onComment;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.onViewed,
    required this.onLike,
    required this.onComment,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.videos.isNotEmpty) {
        widget.onViewed(widget.videos[0]);
      }
    });
  }

  void _handlePageChanged(int index) {
    setState(() => _activeIndex = index);
    widget.onViewed(widget.videos[index]);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: _handlePageChanged,
      itemBuilder: (context, index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            //Video+gradiente
            SizedBox.expand(
              child: FullscreenPlayer(
                videoUrl: videoPost.url,
                caption: videoPost.caption,
                isActive: index == _activeIndex,
              ),
            ),

            //Botones
            Positioned(
              bottom: 40,
              right: 20,
              child: VideoButtons(
                video: videoPost,
                onLike: () => widget.onLike(videoPost),
                onComment: () => widget.onComment(videoPost),
              ),
            ),
          ],
        );
      },
    );
  }
}
