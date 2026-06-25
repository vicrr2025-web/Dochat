
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _strings;

  AppLocalizations(this.locale) {
    _strings = {};
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  void load(Map<String, String> strings) {
    _strings = strings;
  }

  String get appName => _strings['appName'] ?? 'Dochat';
  String get appSlogan => _strings['appSlogan'] ?? '极简联络，一诺可守';
  String get login => _strings['login'] ?? '登录';
  String get register => _strings['register'] ?? '注册';
  String get phoneNumber => _strings['phoneNumber'] ?? '手机号';
  String get password => _strings['password'] ?? '密码';
  String get confirmPassword => _strings['confirmPassword'] ?? '确认密码';
  String get smsCode => _strings['smsCode'] ?? '验证码';
  String get getSmsCode => _strings['getSmsCode'] ?? '获取验证码';
  String get retryAfter => _strings['retryAfter'] ?? 's后重试';
  String get loginViaSms => _strings['loginViaSms'] ?? '验证码登录';
  String get loginViaPassword => _strings['loginViaPassword'] ?? '密码登录';
  String get noAccount => _strings['noAccount'] ?? '还没有账号？注册';
  String get hasAccount => _strings['hasAccount'] ?? '已有账号？登录';
  String get forgotPassword => _strings['forgotPassword'] ?? '忘记密码？';
  String get setPassword => _strings['setPassword'] ?? '设置密码（6-20位，含字母和数字）';
  String get signOut => _strings['signOut'] ?? '退出登录';
  String get signOutConfirm => _strings['signOutConfirm'] ?? '确定要退出登录吗？';
  String get cancel => _strings['cancel'] ?? '取消';
  String get confirm => _strings['confirm'] ?? '确认';
  String get loading => _strings['loading'] ?? '加载中...';
  String get networkError => _strings['networkError'] ?? '网络连接失败，请检查网络';
  String get serverError => _strings['serverError'] ?? '服务器繁忙，请稍后重试';
  String get invalidPhone => _strings['invalidPhone'] ?? '请输入正确的手机号';
  String get phoneRegistered => _strings['phoneRegistered'] ?? '该手机号已注册，请直接登录';
  String get phoneNotRegistered => _strings['phoneNotRegistered'] ?? '该手机号未注册';
  String get smsSent => _strings['smsSent'] ?? '验证码已发送';
  String get smsExpired => _strings['smsExpired'] ?? '验证码已过期，请重新获取';
  String get smsError => _strings['smsError'] ?? '验证码错误';
  String get smsLimit => _strings['smsLimit'] ?? '今日验证码已达上限';
  String get smsTooFrequent => _strings['smsTooFrequent'] ?? '操作过于频繁，请稍后重试';
  String get passwordInvalid => _strings['passwordInvalid'] ?? '密码需6-20位，包含字母和数字';
  String get passwordMismatch => _strings['passwordMismatch'] ?? '两次密码不一致';
  String get passwordWrong => _strings['passwordWrong'] ?? '密码错误';
  String get accountLocked => _strings['accountLocked'] ?? '账号已锁定，请30分钟后重试';
  String get accountBanned => _strings['accountBanned'] ?? '账号已被禁用，请联系客服';
  String get registerSuccess => _strings['registerSuccess'] ?? '注册成功';
  String get loginSuccess => _strings['loginSuccess'] ?? '登录成功';
  String get passwordChanged => _strings['passwordChanged'] ?? '密码修改成功，请重新登录';
  String get passwordReset => _strings['passwordReset'] ?? '密码重置成功';
  String get newPasswordCannotBeSame => _strings['newPasswordCannotBeSame'] ?? '新密码不能与旧密码相同';
  String get currentPassword => _strings['currentPassword'] ?? '当前密码';
  String get newPassword => _strings['newPassword'] ?? '新密码';
  String get changePassword => _strings['changePassword'] ?? '修改密码';
  String get resetPassword => _strings['resetPassword'] ?? '重置密码';
  String get tokenExpired => _strings['tokenExpired'] ?? '登录已过期，请重新登录';
  String get verifyCodeSent => _strings['verifyCodeSent'] ?? '验证码已发送';
  String get sendFailed => _strings['sendFailed'] ?? '发送失败，请重试';

  String tryCount(int remaining) {
    final zh = '密码错误，还剩$remaining次尝试机会';
    final en = 'Wrong password, $remaining attempts remaining';
    return locale.languageCode == 'zh' ? zh : en;
  }

  // ======== M2 聊天核心 ========
  String get chat => _strings['chat'] ?? '聊天';
  String get sessions => _strings['sessions'] ?? '会话';
  String get newChat => _strings['newChat'] ?? '新建聊天';
  String get selectFriend => _strings['selectFriend'] ?? '选择好友';
  String get send => _strings['send'] ?? '发送';
  String get holdToTalk => _strings['holdToTalk'] ?? '按住 说话';
  String get releaseToCancel => _strings['releaseToCancel'] ?? '松手 取消';
  String get recordingTooShort => _strings['recordingTooShort'] ?? '录音时间太短';
  String get copy => _strings['copy'] ?? '复制';
  String get revoke => _strings['revoke'] ?? '撤回';
  String get delete => _strings['delete'] ?? '删除';
  String get pin => _strings['pin'] ?? '置顶';
  String get mute => _strings['mute'] ?? '静音';
  String get search => _strings['search'] ?? '搜索';
  String get picture => _strings['picture'] ?? '图片';
  String get camera => _strings['camera'] ?? '拍照';
  String get file => _strings['file'] ?? '文件';
  String get takePhoto => _strings['takePhoto'] ?? '拍照';
  String get chooseFromAlbum => _strings['chooseFromAlbum'] ?? '从相册选择';
  String get youRecalled => _strings['youRecalled'] ?? '你撤回了一条消息';
  String get otherRecalled => _strings['otherRecalled'] ?? '对方撤回了一条消息';
  String get image => _strings['image'] ?? '图片';
  String get voice => _strings['voice'] ?? '语音';
  String get fileMessage => _strings['fileMessage'] ?? '文件';
  String get comingSoon => _strings['comingSoon'] ?? '即将上线';
  String get read => _strings['read'] ?? '已读';
  String get unread => _strings['unread'] ?? '未读';
  String get justNow => _strings['justNow'] ?? '刚刚';
  String get yesterday => _strings['yesterday'] ?? '昨天';
  String get copied => _strings['copied'] ?? '已复制';
  String get clearChat => _strings['clearChat'] ?? '清空聊天记录';
  String get clearChatConfirm => _strings['clearChatConfirm'] ?? '确定要清空聊天记录吗？';
  String get dismiss => _strings['dismiss'] ?? '解除';
  String get unpin => _strings['unpin'] ?? '取消置顶';
  String get unmute => _strings['unmute'] ?? '取消静音';
  String get noMessages => _strings['noMessages'] ?? '暂无消息';
  String get typing => _strings['typing'] ?? '对方正在输入...';

}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['zh', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(_load(locale));
  }

  AppLocalizations _load(Locale locale) {
    final localizations = AppLocalizations(locale);
    final isZh = locale.languageCode == 'zh';
    localizations.load({
      'appName': isZh ? '电波灵动' : 'Dochat',
      'appSlogan': isZh ? '极简联络，一诺可守' : 'Simple Connect, Keep Promises',
      'login': isZh ? '登录' : 'Sign In',
      'register': isZh ? '注册' : 'Sign Up',
      'phoneNumber': isZh ? '手机号' : 'Phone Number',
      'password': isZh ? '密码' : 'Password',
      'confirmPassword': isZh ? '确认密码' : 'Confirm Password',
      'smsCode': isZh ? '验证码' : 'Verification Code',
      'getSmsCode': isZh ? '获取验证码' : 'Get Code',
      'retryAfter': isZh ? 's后重试' : 's',
      'loginViaSms': isZh ? '验证码登录' : 'Login via SMS',
      'loginViaPassword': isZh ? '密码登录' : 'Login via Password',
      'noAccount': isZh ? '还没有账号？注册' : "Don't have an account? Sign Up",
      'hasAccount': isZh ? '已有账号？登录' : 'Already have an account? Sign In',
      'forgotPassword': isZh ? '忘记密码？' : 'Forgot Password?',
      'setPassword': isZh ? '设置密码（6-20位，含字母和数字）' : 'Set Password (6-20 chars, letters + numbers)',
      'signOut': isZh ? '退出登录' : 'Sign Out',
      'signOutConfirm': isZh ? '确定要退出登录吗？' : 'Are you sure you want to sign out?',
      'cancel': isZh ? '取消' : 'Cancel',
      'confirm': isZh ? '确认' : 'Confirm',
      'loading': isZh ? '加载中...' : 'Loading...',
      'networkError': isZh ? '网络连接失败，请检查网络' : 'Network error, please check your connection',
      'serverError': isZh ? '服务器繁忙，请稍后重试' : 'Server busy, please try again later',
      'invalidPhone': isZh ? '请输入正确的手机号' : 'Please enter a valid phone number',
      'phoneRegistered': isZh ? '该手机号已注册，请直接登录' : 'This phone number is already registered',
      'phoneNotRegistered': isZh ? '该手机号未注册' : 'This phone number is not registered',
      'smsSent': isZh ? '验证码已发送' : 'Verification code sent',
      'smsExpired': isZh ? '验证码已过期，请重新获取' : 'Code expired, please request a new one',
      'smsError': isZh ? '验证码错误' : 'Invalid verification code',
      'smsLimit': isZh ? '今日验证码已达上限' : 'Daily verification code limit reached',
      'smsTooFrequent': isZh ? '操作过于频繁，请稍后重试' : 'Too many requests, please try again later',
      'passwordInvalid': isZh ? '密码需6-20位，包含字母和数字' : 'Password must be 6-20 chars with letters and numbers',
      'passwordMismatch': isZh ? '两次密码不一致' : 'Passwords do not match',
      'passwordWrong': isZh ? '密码错误' : 'Wrong password',
      'accountLocked': isZh ? '账号已锁定，请30分钟后重试' : 'Account locked, please try again in 30 minutes',
      'accountBanned': isZh ? '账号已被禁用，请联系客服' : 'Account banned, please contact support',
      'registerSuccess': isZh ? '注册成功' : 'Registration successful',
      'loginSuccess': isZh ? '登录成功' : 'Login successful',
      'passwordChanged': isZh ? '密码修改成功，请重新登录' : 'Password changed, please sign in again',
      'passwordReset': isZh ? '密码重置成功' : 'Password reset successful',
      'newPasswordCannotBeSame': isZh ? '新密码不能与旧密码相同' : 'New password cannot be the same as old password',
      'currentPassword': isZh ? '当前密码' : 'Current Password',
      'newPassword': isZh ? '新密码' : 'New Password',
      'changePassword': isZh ? '修改密码' : 'Change Password',
      'resetPassword': isZh ? '重置密码' : 'Reset Password',
      'tokenExpired': isZh ? '登录已过期，请重新登录' : 'Session expired, please sign in again',
      'verifyCodeSent': isZh ? '验证码已发送' : 'Verification code sent',
      'sendFailed': isZh ? '发送失败，请重试' : 'Send failed, please try again',
      'chat': isZh ? '聊天' : 'Chat',
      'sessions': isZh ? '会话' : 'Sessions',
      'newChat': isZh ? '新建聊天' : 'New Chat',
      'selectFriend': isZh ? '选择好友' : 'Select Friend',
      'send': isZh ? '发送' : 'Send',
      'holdToTalk': isZh ? '按住 说话' : 'Hold to Talk',
      'releaseToCancel': isZh ? '松手 取消' : 'Release to Cancel',
      'recordingTooShort': isZh ? '录音时间太短' : 'Recording too short',
      'copy': isZh ? '复制' : 'Copy',
      'revoke': isZh ? '撤回' : 'Revoke',
      'delete': isZh ? '删除' : 'Delete',
      'pin': isZh ? '置顶' : 'Pin',
      'mute': isZh ? '静音' : 'Mute',
      'search': isZh ? '搜索' : 'Search',
      'picture': isZh ? '图片' : 'Picture',
      'camera': isZh ? '拍照' : 'Camera',
      'file': isZh ? '文件' : 'File',
      'takePhoto': isZh ? '拍照' : 'Take Photo',
      'chooseFromAlbum': isZh ? '从相册选择' : 'Choose from Album',
      'youRecalled': isZh ? '你撤回了一条消息' : 'You recalled a message',
      'otherRecalled': isZh ? '对方撤回了一条消息' : 'The other party recalled a message',
      'image': isZh ? '图片' : 'Image',
      'voice': isZh ? '语音' : 'Voice',
      'fileMessage': isZh ? '文件' : 'File',
      'comingSoon': isZh ? '即将上线' : 'Coming Soon',
      'read': isZh ? '已读' : 'Read',
      'unread': isZh ? '未读' : 'Unread',
      'justNow': isZh ? '刚刚' : 'Just now',
      'yesterday': isZh ? '昨天' : 'Yesterday',
      'copied': isZh ? '已复制' : 'Copied',
      'clearChat': isZh ? '清空聊天记录' : 'Clear Chat History',
      'clearChatConfirm': isZh ? '确定要清空聊天记录吗？' : 'Are you sure you want to clear chat history?',
      'dismiss': isZh ? '解除' : 'Dismiss',
      'unpin': isZh ? '取消置顶' : 'Unpin',
      'unmute': isZh ? '取消静音' : 'Unmute',
      'noMessages': isZh ? '暂无消息' : 'No messages',
      'typing': isZh ? '对方正在输入...' : 'Typing...',
    });
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
