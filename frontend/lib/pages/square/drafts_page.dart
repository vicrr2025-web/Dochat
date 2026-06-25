import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/services/post_service.dart';
import 'package:dochat_app/pages/square/create_post_page.dart';

class DraftsPage extends StatefulWidget {
  const DraftsPage({super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  final PostService _postService = PostService();
  List<PostInfo> _drafts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    try {
      final drafts = await _postService.getDrafts();
      setState(() {
        _drafts = drafts;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDraft(String postId) async {
    try {
      await _postService.deletePost(postId);
      setState(() {
        _drafts.removeWhere((d) => d.postId == postId);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.drafts),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _drafts.isEmpty
                ? Center(
                    child: Text(
                      l10n.noDrafts,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _drafts.length,
                    itemBuilder: (context, index) {
                      final draft = _drafts[index];
                      return Dismissible(
                        key: Key(draft.postId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: CupertinoColors.destructiveRed,
                          child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
                        ),
                        onDismissed: (_) => _deleteDraft(draft.postId),
                        child: CupertinoListTile(
                          title: Text(
                            draft.content ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            draft.createdAt,
                            style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                          ),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => CreatePostPage(draft: draft),
                              ),
                            );
                            _loadDrafts();
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
