import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:e201_toktik/presentation/providers/discover_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DiscoverProvider provider;

  setUp(() {
    provider = DiscoverProvider()
      ..videos = [
        VideoPost(caption: 'Video de prueba', url: 'video.mp4', likes: 4),
      ];
  });

  test('registra vistas y permite alternar el like', () {
    provider.recordView('video.mp4');
    provider.toggleLike('video.mp4');

    expect(provider.videos.single.views, 1);
    expect(provider.videos.single.likes, 5);
    expect(provider.videos.single.isLiked, isTrue);

    provider.toggleLike('video.mp4');

    expect(provider.videos.single.likes, 4);
    expect(provider.videos.single.isLiked, isFalse);
  });

  test('agrega comentarios no vacíos al video correspondiente', () {
    provider.addComment('video.mp4', '  Buen video  ');
    provider.addComment('video.mp4', '   ');

    expect(provider.videos.single.comments, ['Buen video']);
  });

  test('genera un texto compartible para videos locales y remotos', () {
    final localVideo = VideoPost(
      caption: 'Video local',
      url: 'assets/videos/1b.mp4',
    );
    final remoteVideo = VideoPost(
      caption: 'Video remoto',
      url: 'https://example.com/video.mp4',
    );

    expect(
      localVideo.shareText,
      'Mira este video "Video local": https://toktik.app/watch?title=Video%20local',
    );
    expect(
      remoteVideo.shareText,
      'Mira este video "Video remoto": https://example.com/video.mp4',
    );
  });
}
