import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/services/post_service.dart';
import 'package:dochat_app/services/chat_service.dart';
import 'package:dochat_app/providers/post_provider.dart';
import 'package:dochat_app/pages/chat/image_picker_sheet.dart';

class CreatePostPage extends StatefulWidget {
  final PostInfo? draft;

  const CreatePostPage({super.key, this.draft});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _contentController;
  String _visibility = 'public';
  final List<String> _selectedFiles = [];
  String _mediaType = 'text';
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.draft?.content ?? '',
    );
    _contentController.addListener(() {
      setState(() {
        _hasContent = _contentController.text.trim().isNotEmpty;
      });
    });
    _hasContent = _contentController.text.trim().isNotEmpty;
    if (widget.draft != null) {
      _mediaType = widget.draft!.mediaType;
      _visibility = widget.draft!.visibility;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasContent) return true;
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return CupertinoAlertDialog(
          title: Text(l10n.discardEdit),
          content: Text(l10n.discardEditHint),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(l10n.confirm),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_hasContent,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            onTap: () async {
              final shouldPop = !_hasContent || await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.cancel,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          middle: Text(l10n.newPost),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              l10n.publish,
              style: TextStyle(
                color: _hasContent ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: _hasContent ? _publish : null,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoTextField(
                  controller: _contentController,
                  placeholder: l10n.shareThoughts,
                  maxLines: 6,
                  maxLength: 140,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildMediaButton(l10n.addPhotos, CupertinoIcons.photo, 'image'),
                    const SizedBox(width: 12),
                    _buildMediaButton(l10n.addVideo, CupertinoIcons.videocam, 'video'),
                  ],
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.location, size: 18, color: CupertinoColors.systemGrey),
                      const SizedBox(width: 4),
                      Text(
                        l10n.addLocation,
                        style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.addLocation),
                        content: Text(l10n.locationComingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CupertinoSlidingSegmentedControl<String>(
                  groupValue: _visibility,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() => _visibility = value);
                    }
                  },
                  children: {
                    'public': Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(l10n.public),
                    ),
                    'friends': Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(l10n.friendsOnly),
                    ),
                    'private': Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(l10n.private),
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaButton(String label, IconData icon, String type) {
    return GestureDetector(
      onTap: () {
        if (type == 'image') {
          showCupertinoModalPopup(
            context: context,
            builder: (_) => const ImagePickerSheet(),
          ).then((result) {
            if (result == 'camera' || result == 'album') {
              setState(() {
                _mediaType = type;
              });
            }
          });
        } else {
          setState(() {
            _mediaType = type;
          });
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 20, color: CupertinoColors.systemGrey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }

  Future<void> _publish() async {
    final provider = context.read<PostProvider>();
    final chatService = ChatService();
    
    // Upload media files if selected
    final List<String> uploadedUrls = [];
    for (final file in _selectedFiles) {
      final url = await chatService.uploadFile(file);
      if (url != null) uploadedUrls.add(url);
    }
    
    final request = PostRequest(
      content: _contentController.text.trim(),
      mediaType: _mediaType,
      mediaUrls: uploadedUrls,
      visibility: _visibility,
    );
    final post = await provider.createPost(request);
    if (post != null && mounted) {
      Navigator.pop(context);
    }
  }
}
