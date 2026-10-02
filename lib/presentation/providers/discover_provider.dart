import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/infrastructure/models/local_video_model.dart';
import 'package:e201_toktik/shared/data/local_video_post.dart';
import 'package:flutter/material.dart';

class DiscoverProvider extends ChangeNotifier {
  //TODO: Repositorios, Datasource

  bool initialLoading = true;

  List<VideoPost> videos = [];

  void toggleLike(String videoUrl) {
    _updateVideo(
      videoUrl,
      (video) => video.copyWith(
        likes: video.likes + (video.isLiked ? -1 : 1),
        isLiked: !video.isLiked,
      ),
    );
  }

  void recordView(String videoUrl) {
    _updateVideo(videoUrl, (video) => video.copyWith(views: video.views + 1));
  }

  void addComment(String videoUrl, String comment) {
    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) return;

    _updateVideo(
      videoUrl,
      (video) => video.copyWith(comments: [...video.comments, trimmedComment]),
    );
  }

  void _updateVideo(String videoUrl, VideoPost Function(VideoPost) update) {
    final videoIndex = videos.indexWhere((video) => video.url == videoUrl);
    if (videoIndex == -1) return;

    videos[videoIndex] = update(videos[videoIndex]);
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    await Future.delayed(Duration(seconds: 2));

    final List<VideoPost> newVideos = videoPosts
        .map((video) => LocalVideoModel.fromJson(video).toVideoPostEntity())
        .toList();
    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }
}
