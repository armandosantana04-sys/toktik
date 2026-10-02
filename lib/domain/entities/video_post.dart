class VideoPost {
  final String caption;
  final String url;
  final int likes;
  final int views;
  final bool isLiked;
  final List<String> comments;

  VideoPost({
    required this.caption,
    required this.url,
    this.likes = 0,
    this.views = 0,
    this.isLiked = false,
    this.comments = const [],
  });

  VideoPost copyWith({
    int? likes,
    int? views,
    bool? isLiked,
    List<String>? comments,
  }) => VideoPost(
    caption: caption,
    url: url,
    likes: likes ?? this.likes,
    views: views ?? this.views,
    isLiked: isLiked ?? this.isLiked,
    comments: comments ?? this.comments,
  );
}
