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

  bool get hasHttpUrl {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String get shareUrl {
    if (hasHttpUrl) return url;
    return 'https://toktik.app/watch?title=${Uri.encodeComponent(caption)}';
  }

  String get shareText {
    return 'Mira este video "$caption": $shareUrl';
  }

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
