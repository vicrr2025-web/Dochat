// ignore_for_file: use_build_context_synchronously
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';

class SelectFriendPage extends StatefulWidget {
  const SelectFriendPage({super.key});

  @override
  State<SelectFriendPage> createState() => _SelectFriendPageState();
}

class _SelectFriendPageState extends State<SelectFriendPage> {
  List<Map<String, dynamic>> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    setState(() => _isLoading = true);

    // Mock friends list for M2
    await Future.delayed(const Duration(milliseconds: 400));
    final mockFriends = List.generate(
      Random().nextInt(8) + 3,
      (i) => {
        'userId': 'user_${1000 + i}',
        'nickname': _mockNames[i % _mockNames.length],
        'avatar': null,
      },
    );
    setState(() {
      _friends = mockFriends;
      _isLoading = false;
    });
  }

  static const _mockNames = [
    '张三',
    '李四',
    '王五',
    '赵六',
    'Alice',
    'Bob',
    'Charlie',
    'Diana',
    'Emma',
    'James',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.selectFriend),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _friends.isEmpty
                ? Center(
                    child: Text(
                      l10n.noMessages,
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _friends.length,
                    itemBuilder: (context, index) {
                      final friend = _friends[index];
                      return CupertinoListTile(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leadingSize: 44,
                        leading: ClipOval(
                          child: Container(
                            width: 44,
                            height: 44,
                            color: const Color(0xFFE9E9EB),
                            child: const Icon(
                              CupertinoIcons.person_fill,
                              color: Color(0xFF8E8E93),
                              size: 24,
                            ),
                          ),
                        ),
                        title: Text(
                          friend['nickname'] as String? ?? '',
                          style: const TextStyle(fontSize: 17),
                        ),
                        onTap: () async {
                          if (!mounted) return;
                          final chat = context.read<ChatProvider>();
                          final navigator = Navigator.of(context);
                          final userId = friend['userId'] as String;
                          try {
                            final session = await chat.createSession(userId);
                            if (!mounted) return;
                            navigator.pushReplacement(
                              CupertinoPageRoute(
                                builder: (_) => ChatPage(session: session),
                              ),
                            );
                          } catch (_) {
                            if (!mounted) return;
                                            showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                content: Text(l10n.serverError),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(l10n.confirm),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
