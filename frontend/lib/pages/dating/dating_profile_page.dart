import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingProfilePage extends StatefulWidget {
  const DatingProfilePage({super.key});

  @override
  State<DatingProfilePage> createState() => _DatingProfilePageState();
}

class _DatingProfilePageState extends State<DatingProfilePage> {
  final _aboutMeController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedBirthday;
  int? _selectedHeight;
  String? _selectedEducation;
  String? _selectedIncome;
  String? _selectedMaritalStatus;
  String _tags = '';
  bool _saving = false;

  static const _heightValues = [150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200];
  static const _educationOptions = ['高中', '大专', '本科', '硕士', '博士'];
  static const _incomeOptions = ['3k以下', '3k-5k', '5k-10k', '10k-20k', '20k-50k', '50k以上'];
  static const _maritalOptions = ['未婚', '离异', '丧偶'];
  static const _tagOptions = ['运动', '旅游', '美食', '音乐', '电影', '读书', '宠物', '摄影', '游戏', '健身'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DatingProvider>();
      provider.loadProfile().then((_) {
        final p = provider.profile;
        if (p != null) {
          setState(() {
            _selectedGender = p.gender;
            if (p.birthday != null) _selectedBirthday = DateTime.tryParse(p.birthday!);
            _selectedHeight = p.height;
            _selectedEducation = p.education;
            _selectedIncome = p.income;
            _selectedMaritalStatus = p.maritalStatus;
            _tags = p.tags ?? '';
            _aboutMeController.text = p.aboutMe ?? '';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedGender == null) {
      _showToast('请选择性别');
      return;
    }
    setState(() => _saving = true);
    final provider = context.read<DatingProvider>();
    final body = <String, dynamic>{
      'gender': _selectedGender,
      'birthday': _formatDate(_selectedBirthday),
      'height': _selectedHeight,
      'education': _selectedEducation,
      'income': _selectedIncome,
      'maritalStatus': _selectedMaritalStatus,
      'tags': _tags,
      'aboutMe': _aboutMeController.text,
    };
    final ok = await provider.updateProfile(body);
    setState(() => _saving = false);
    if (ok && mounted) {
      _showToast('保存成功');
    }
  }

  void _showToast(String msg) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(content: Text(msg), actions: [
        CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context)),
      ]),
    );
  }

  Widget _buildPickerTile(String label, String? value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E))),
              Row(
                children: [
                  Text(value ?? '', style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey)),
                  const SizedBox(width: 4),
                  const Icon(CupertinoIcons.chevron_right, size: 18, color: CupertinoColors.systemGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickOption(String title, List<String> options, String? current, Function(String) onSelect) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final selected = current ?? options.first;
        int idx = options.indexOf(selected);
        if (idx < 0) idx = 0;
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: CupertinoColors.systemGrey6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(padding: EdgeInsets.zero, child: const Text('取消'), onPressed: () => Navigator.pop(context)),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('确定'),
                      onPressed: () {
                        onSelect(options[idx]);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: idx),
                  itemExtent: 40,
                  onSelectedItemChanged: (i) => idx = i,
                  children: options.map((o) => Center(child: Text(o, style: const TextStyle(fontSize: 18)))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickTags() {
    final l10n = AppLocalizations.of(context);
    final currentTags = _tags.isNotEmpty ? _tags.split(',').toSet() : <String>{};
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemGrey6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(padding: EdgeInsets.zero, child: const Text('取消'), onPressed: () => Navigator.pop(context)),
                  Text(l10n.tagsLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('确定'),
                    onPressed: () {
                      setState(() => _tags = currentTags.join(','));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tagOptions.map((tag) {
                    final selected = currentTags.contains(tag);
                    return GestureDetector(
                      onTap: () {
                        if (selected) {
                          currentTags.remove(tag);
                        } else {
                          currentTags.add(tag);
                        }
                        (context as Element).markNeedsBuild();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag, style: TextStyle(color: selected ? CupertinoColors.white : const Color(0xFF3C3C43))),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.editProfile),
        trailing: _saving
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('保存', style: TextStyle(fontSize: 16)),
                onPressed: _save,
              ),
      ),
      child: SafeArea(
        child: provider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                children: [
                  _buildPickerTile('${l10n.gender}: ${_selectedGender ?? ''}', null, () {
                    _pickOption(l10n.gender, ['male', 'female'], _selectedGender, (v) {
                      setState(() => _selectedGender = v);
                    });
                  }),
                  _buildPickerTile('${l10n.birthdayLabel}: ${_formatDate(_selectedBirthday)}', null, () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => Container(
                        height: 260,
                        color: CupertinoColors.systemBackground,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              color: CupertinoColors.systemGrey6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(padding: EdgeInsets.zero, child: const Text('取消'), onPressed: () => Navigator.pop(context)),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Text('确定'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: _selectedBirthday ?? DateTime(2000),
                                minimumDate: DateTime(1940),
                                maximumDate: DateTime.now(),
                                onDateTimeChanged: (dt) => setState(() => _selectedBirthday = dt),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  _buildPickerTile('${l10n.heightLabel}: ${_selectedHeight != null ? '${_selectedHeight}cm' : ''}', null, () {
                    int idx = _selectedHeight != null ? _heightValues.indexOf(_selectedHeight!) : 4;
                    if (idx < 0) idx = 4;
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) {
                        int selectedIdx = idx;
                        return Container(
                          height: 260,
                          color: CupertinoColors.systemBackground,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                color: CupertinoColors.systemGrey6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(padding: EdgeInsets.zero, child: const Text('取消'), onPressed: () => Navigator.pop(context)),
                                    Text(l10n.heightLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Text('确定'),
                                      onPressed: () {
                                        setState(() => _selectedHeight = _heightValues[selectedIdx]);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: selectedIdx),
                                  itemExtent: 40,
                                  onSelectedItemChanged: (i) => selectedIdx = i,
                                  children: _heightValues.map((h) => Center(child: Text('${h}cm', style: const TextStyle(fontSize: 18)))).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  _buildPickerTile(
                    l10n.educationLabel,
                    _selectedEducation,
                    () => _pickOption(l10n.educationLabel, _educationOptions, _selectedEducation, (v) => setState(() => _selectedEducation = v)),
                  ),
                  _buildPickerTile(
                    l10n.incomeLabel,
                    _selectedIncome,
                    () => _pickOption(l10n.incomeLabel, _incomeOptions, _selectedIncome, (v) => setState(() => _selectedIncome = v)),
                  ),
                  _buildPickerTile(
                    l10n.maritalStatusLabel,
                    _selectedMaritalStatus,
                    () => _pickOption(l10n.maritalStatusLabel, _maritalOptions, _selectedMaritalStatus, (v) => setState(() => _selectedMaritalStatus = v)),
                  ),
                  _buildPickerTile(l10n.tagsLabel, _tags.isNotEmpty ? _tags : null, _pickTags),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.aboutMeLabel, style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E))),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              color: CupertinoColors.systemGrey5,
                              borderRadius: BorderRadius.circular(16),
                              child: Text(l10n.aiGenerate, style: const TextStyle(fontSize: 14)),
                              onPressed: () {
                                _aboutMeController.text = '我是一个热爱生活、积极向上的人，希望在这里遇到有缘人。喜欢运动、旅行和美食。';
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CupertinoTextField(
                            controller: _aboutMeController,
                            maxLines: 5,
                            placeholder: l10n.aboutMeLabel,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
