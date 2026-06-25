import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobCompanyPage extends StatefulWidget {
  const JobCompanyPage({super.key});

  @override
  State<JobCompanyPage> createState() => _JobCompanyPageState();
}

class _JobCompanyPageState extends State<JobCompanyPage> {
  final _nameCtl = TextEditingController();
  final _industryCtl = TextEditingController();
  final _scaleCtl = TextEditingController();
  final _addressCtl = TextEditingController();
  final _descCtl = TextEditingController();
  bool _saving = false;
  String _authStatus = 'pending';

  @override
  void dispose() {
    _nameCtl.dispose();
    _industryCtl.dispose();
    _scaleCtl.dispose();
    _addressCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Color _authColor() {
    switch (_authStatus) {
      case 'verified': return const Color(0xFF34C759);
      case 'pending': return const Color(0xFFFF9500);
      case 'rejected': return const Color(0xFFFF3B30);
      default: return CupertinoColors.systemGrey;
    }
  }

  String _authText(AppLocalizations l10n) {
    switch (_authStatus) {
      case 'verified': return '已认证';
      case 'pending': return '审核中';
      case 'rejected': return '已驳回';
      default: return '未认证';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobCompany),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: _saving ? const CupertinoActivityIndicator() : Text(l10n.confirm, style: const TextStyle(fontWeight: FontWeight.w600)),
          onPressed: _saving
              ? null
              : () async {
                  setState(() => _saving = true);
                  final provider = context.read<JobProvider>();
                  await provider.companyAuth({
                    'name': _nameCtl.text,
                    'industry': _industryCtl.text,
                    'scale': _scaleCtl.text,
                    'address': _addressCtl.text,
                    'description': _descCtl.text,
                  });
                  setState(() {
                    _saving = false;
                    _authStatus = 'pending';
                  });
                  if (mounted) {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        content: const Text('提交成功，请等待审核'),
                        actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                      ),
                    );
                  }
                },
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAuthBadge(l10n),
            const SizedBox(height: 16),
            _field('企业名称', _nameCtl),
            _field('所属行业', _industryCtl),
            _field(l10n.enterpriseScale, _scaleCtl),
            _field('企业地址', _addressCtl),
            _field('企业简介', _descCtl, multiline: true),
            const SizedBox(height: 16),
            _sectionLabel(l10n.licenseUpload),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    content: const Text('模拟上传营业执照'),
                    actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(CupertinoIcons.photo, size: 36, color: CupertinoColors.systemGrey),
                    const SizedBox(height: 8),
                    Text(l10n.licenseUpload, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _authColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _authColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.checkmark_seal_fill, color: _authColor(), size: 24),
          const SizedBox(width: 12),
          Text(_authText(l10n), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _authColor())),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctl, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey)),
    );
  }
}
