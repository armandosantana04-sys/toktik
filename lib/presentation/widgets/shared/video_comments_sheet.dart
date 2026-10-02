import 'package:e201_toktik/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

void showVideoComments(
  BuildContext context, {
  required VideoPost video,
  required ValueChanged<String> onSubmit,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _VideoCommentsSheet(video: video, onSubmit: onSubmit),
  );
}

class _VideoCommentsSheet extends StatefulWidget {
  final VideoPost video;
  final ValueChanged<String> onSubmit;

  const _VideoCommentsSheet({required this.video, required this.onSubmit});

  @override
  State<_VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<_VideoCommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  late List<String> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.of(widget.video.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    widget.onSubmit(comment);
    setState(() => _comments.add(comment));
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.68,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_comments.length} comentarios',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar comentarios',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _comments.isEmpty
                  ? Center(
                      child: Text(
                        'Aún no hay comentarios',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          child: const Text('T'),
                        ),
                        title: Text('Tú', style: theme.textTheme.labelLarge),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(_comments[index]),
                        ),
                        trailing: const Icon(Icons.favorite_border, size: 18),
                      ),
                    ),
            ),
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 17, child: Text('T')),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Añade un comentario...',
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _submitComment(),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Publicar comentario',
                      onPressed: _submitComment,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
