import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobResumePage extends StatefulWidget {
  const JobResumePage({super.key});

  @override
  State<JobResumePage> createState() => _JobResumePageState();
}

class _JobResumePageState extends State<JobResumePage> {
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _educationCtl = TextEditingController();
  final _experienceCtl = TextEditingController();
  final _skillsCtl = TextEditingController();
  final _intentionCtl = TextEditingController();
  bool _saving = false;
  String _privacy = 'public';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JobProvider>();
      provider.loadResume().then((_) {
        final r = provider.resume;
        if (r != null) {
          setState(() {
            _nameCtl.text = r.name ?? '';
            _phoneCtl.text = r.phone ?? '';
            _emailCtl.text = r.email ?? '';
            _educationCtl.text = r.education ?? '';
            _experienceCtl.text = r.experience ?? '';
            _skillsCtl.text = r.skills ?? '';
            _intentionCtl.text = r.intention ?? '';
            _privacy = r.privacy ?? 'public';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _emailCtl.dispose();
    _educationCtl.dispose();
    _experienceCtl.dispose();
    _skillsCtl.dispose();
    _intentionCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final provider = context.read<JobProvider>();
    final ok = await provider.saveResume({
      'name': _nameCtl.text,
      'phone': _phoneCtl.text,
      'email': _emailCtl.text,
      'education': _educationCtl.text,
      'experience': _experienceCtl.text,
      'skills': _skillsCtl.text,
      'intention': _intentionCtl.text,
      'privacy': _privacy,
    });
    setState(() => _saving = false);
    if (ok && mounted) {
      showCupertinoDialog(
        context: context,
        builder: (_) => const CupertinoAlertDialog(
          content: Text('保存成功'),
          actions: [CupertinoDialogAction(child: Text('OK'), onPressed: null, isDefaultAction: true)],
        ),
      );
    }
  }

  Widget _field(String label, TextEditingController ctl, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CupertinoTextField(
          controller: ctl,
          placeholder: label,
          maxLines: multiline ? 4 : 1,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobResume),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: _saving ? const CupertinoActivityIndicator() : Text(l10n.confirm, style: const TextStyle(fontWeight: FontWeight.w600)),
          onPressed: _saving ? null : _save,
        ),
      ),
      child: SafeArea(
        child: Consumer<JobProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.resume == null) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return ListView(
              children: [
                _sectionLabel('基本信息'),
                _field('姓名', _nameCtl),
                _field('手机号', _phoneCtl),
                _field('邮箱', _emailCtl),
                _sectionLabel(l10n.educationLabel),
                _field(l10n.educationLabel, _educationCtl, multiline: true),
                _sectionLabel('工作经历'),
                _field('工作经历', _experienceCtl, multiline: true),
                _sectionLabel('技能标签'),
                _field('技能标签（逗号分隔）', _skillsCtl),
                _sectionLabel(l10n.jobIntention),
                _field(l10n.jobIntention, _intentionCtl),
                _sectionLabel(l10n.resumePrivacy),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: _privacy,
                      children: const {
                        'public': Text('公开'),
                        'shield': Text('屏蔽企业'),
                        'private': Text('保密'),
                      },
                      onValueChanged: (v) {
                        if (v != null) setState(() => _privacy = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
