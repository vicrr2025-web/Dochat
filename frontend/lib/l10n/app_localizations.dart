
import 'package:flutter/widgets.dart';
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
  String get wrongPassword => _strings['wrongPassword'] ?? '密码错误';
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

  
  String get sendMessage => _strings['sendMessage'] ?? '发消息';
  String get creditScore => _strings['creditScore'] ?? '信誉分';
  String get envMonitor => _strings['envMonitor'] ?? '环境监听';
  String get cameraView => _strings['cameraView'] ?? '摄像头查看';
  String get noGeoFences => _strings['noGeoFences'] ?? '暂无电子围栏';
  String get addGeoFence => _strings['addGeoFence'] ?? '添加围栏';
  String get fenceName => _strings['fenceName'] ?? '围栏名称';
  String get latitude => _strings['latitude'] ?? '纬度';
  String get longitude => _strings['longitude'] ?? '经度';
  String get radius => _strings['radius'] ?? '半径';
  String get radiusUnit => _strings['radiusUnit'] ?? '米';
  String get playing => _strings['playing'] ?? '播放中...';
  String get play => _strings['play'] ?? '播放';
  String get points => _strings['points'] ?? '点';
  String get noTrajectoryData => _strings['noTrajectoryData'] ?? '暂无轨迹数据';

  
  String get justNow => _strings['justNow'] ?? '刚刚';
  String get minAgo => _strings['minAgo'] ?? '分钟前';
  String get hourAgo => _strings['hourAgo'] ?? '小时前';
  String get dayAgo => _strings['dayAgo'] ?? '天前';
  String get reply => _strings['reply'] ?? '回复';
  String get myFollowing => _strings['myFollowing'] ?? '我的关注';
  String get myFollowers => _strings['myFollowers'] ?? '我的粉丝';
  String get posts_ => _strings['posts_'] ?? '动态';
  String get userLabel => _strings['userLabel'] ?? '用户';

  String get discardEdit => _strings['discardEdit'] ?? '放弃编辑？';
  String get discardEditHint => _strings['discardEditHint'] ?? '退出后内容不会保存';

  String userIdLabel(String id) {
    final label = _strings['userIdLabel'];
    if (label != null) return label.replaceAll('{id}', id);
    return 'ID: $id';
  }

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
  String get yesterday => _strings['yesterday'] ?? '昨天';
  String get copied => _strings['copied'] ?? '已复制';
  String get clearChat => _strings['clearChat'] ?? '清空聊天记录';
  String get clearChatConfirm => _strings['clearChatConfirm'] ?? '确定要清空聊天记录吗？';
  String get dismiss => _strings['dismiss'] ?? '解除';
  String get unpin => _strings['unpin'] ?? '取消置顶';
  String get unmute => _strings['unmute'] ?? '取消静音';
  String get noMessages => _strings['noMessages'] ?? '暂无消息';
  String get typing => _strings['typing'] ?? '对方正在输入...';

  // ======== M3 好友 & 定位 ========
  String get friends => _strings['friends'] ?? '好友';
  String get groups => _strings['groups'] ?? '群聊';
  String get friendRequests => _strings['friendRequests'] ?? '好友申请';
  String get addFriend => _strings['addFriend'] ?? '添加好友';
  String get searchFriend => _strings['searchFriend'] ?? '搜索好友';
  String get enterPhone => _strings['enterPhone'] ?? '输入手机号';
  String get sendRequest => _strings['sendRequest'] ?? '发送好友申请';
  String get accept => _strings['accept'] ?? '接受';
  String get reject => _strings['reject'] ?? '拒绝';
  String get accepted => _strings['accepted'] ?? '已接受';
  String get rejected => _strings['rejected'] ?? '已拒绝';
  String get removeFriend => _strings['removeFriend'] ?? '删除好友';
  String get removeFriendConfirm => _strings['removeFriendConfirm'] ?? '确定要删除该好友吗？';
  String get friendRequestSent => _strings['friendRequestSent'] ?? '好友申请已发送';
  String get alreadyFriends => _strings['alreadyFriends'] ?? '已经是好友';
  String get liveLocation => _strings['liveLocation'] ?? '实时定位';
  String get trajectory => _strings['trajectory'] ?? '轨迹回放';
  String get geofence => _strings['geofence'] ?? '电子围栏';
  String get shareLocation => _strings['shareLocation'] ?? '共享位置';
  String get distance => _strings['distance'] ?? '距离';
  String get battery => _strings['battery'] ?? '电量';
  String get noPendingRequests => _strings['noPendingRequests'] ?? '暂无好友申请';
  String get userNotFound => _strings['userNotFound'] ?? '未找到该用户';
  String get requestMessageHint => _strings['requestMessageHint'] ?? '你好，我想加你为好友';

  String get square => _strings['square'] ?? '动态';
  String get recommend => _strings['recommend'] ?? '推荐';
  String get following => _strings['following'] ?? '关注';
  String get moments => _strings['moments'] ?? '动态';
  String get follow => _strings['follow'] ?? '关注';
  String get followingLabel => _strings['following_label'] ?? '已关注';
  String get unfollow => _strings['unfollow'] ?? '取消关注';
  String get newPost => _strings['newPost'] ?? '发布动态';
  String get shareThoughts => _strings['shareThoughts'] ?? '分享你的想法...';
  String get publish => _strings['publish'] ?? '发布';
  String get addPhotos => _strings['addPhotos'] ?? '添加图片';
  String get addVideo => _strings['addVideo'] ?? '添加视频';
  String get addLocation => _strings['addLocation'] ?? '添加位置';
  String get locationComingSoon => _strings['locationComingSoon'] ?? '位置功能即将上线';
  String get public => _strings['public'] ?? '公开';
  String get friendsOnly => _strings['friendsOnly'] ?? '好友';
  String get private => _strings['private'] ?? '私密';
  String get expand => _strings['expand'] ?? '全文';
  String get collapse => _strings['collapse'] ?? '收起';
  String get noComments => _strings['noComments'] ?? '暂无评论';
  String get comments => _strings['comments'] ?? '评论';
  String get saySomething => _strings['saySomething'] ?? '说点什么...';
  String get drafts => _strings['drafts'] ?? '草稿箱';
  String get noDrafts => _strings['noDrafts'] ?? '暂无草稿';
  String get myPosts => _strings['myPosts'] ?? '我的动态';
  String get favorites => _strings['favorites'] ?? '收藏';
  String get viewHistory => _strings['viewHistory'] ?? '浏览记录';
  String get editProfile => _strings['editProfile'] ?? '编辑资料';
  String get noPosts => _strings['noPosts'] ?? '暂无动态';
  String get videoMode => _strings['videoMode'] ?? '视频模式';
  String get like => _strings['like'] ?? '赞';
  String get comment => _strings['comment'] ?? '评论';
  String get share => _strings['share'] ?? '转发';
  String get profile => _strings['profile'] ?? '我的';

  String get chats => _strings['chats'] ?? '聊天';
  String get services => _strings['services'] ?? '服务';
  String get recentlyUsed => _strings['recentlyUsed'] ?? '最近使用';
  String get noRecent => _strings['noRecent'] ?? '暂无使用记录';
  String get serviceHub => _strings['serviceHub'] ?? '服务中心';
  String get guarantee => _strings['guarantee'] ?? '担保';
  String get mall => _strings['mall'] ?? '商城';
  String get dating => _strings['dating'] ?? '婚恋';
  String get housing => _strings['housing'] ?? '找房';
  String get recruit => _strings['recruit'] ?? '直聘';
  String get emailService => _strings['emailService'] ?? '邮箱';
  String get shipping => _strings['shipping'] ?? '速运';
  String get homeService => _strings['homeService'] ?? '到家';

  String get settings => _strings['settings'] ?? '设置';
  String get account => _strings['account'] ?? '账号';
  String get general => _strings['general'] ?? '通用';
  String get storage_label => _strings['storage_label'] ?? '存储';
  String get about => _strings['about'] ?? '关于';
  String get realNameVerify => _strings['realNameVerify'] ?? '实名认证';
  String get verified => _strings['verified'] ?? '已认证';
  String get unverified => _strings['unverified'] ?? '未认证';
  String get deviceManagement => _strings['deviceManagement'] ?? '设备管理';
  String get currentDevice => _strings['currentDevice'] ?? '当前设备';
  String get darkMode => _strings['darkMode'] ?? '深色模式';
  String get language => _strings['language'] ?? '多语言';
  String get paymentSettings => _strings['paymentSettings'] ?? '支付设置';
  String get storageManagement => _strings['storageManagement'] ?? '存储管理';
  String get clearCache => _strings['clearCache'] ?? '清除缓存';
  String get feedback => _strings['feedback'] ?? '帮助与反馈';
  String get aboutUs => _strings['aboutUs'] ?? '关于我们';
  String get userAgreement => _strings['userAgreement'] ?? '用户协议';
  String get privacyPolicy => _strings['privacyPolicy'] ?? '隐私政策';
  String get deleteAccount => _strings['deleteAccount'] ?? '注销账号';
  String get onlineVisibility => _strings['onlineVisibility'] ?? '在线状态';
  String get avatarVisibility => _strings['avatarVisibility'] ?? '头像可见';
  String get bioVisibility => _strings['bioVisibility'] ?? '简介可见';
  String get messagePermission => _strings['messagePermission'] ?? '消息权限';
  String get everyone => _strings['everyone'] ?? '所有人';
  String get nobody => _strings['nobody'] ?? '无人';
  String get blacklist => _strings['blacklist'] ?? '黑名单';
  String get noBlacklist => _strings['noBlacklist'] ?? '暂无黑名单';
  String get creditScoreLabel => _strings['creditScoreLabel'] ?? '信誉分';
  String get signOutMessage => _strings['signOutMessage'] ?? '退出后需要重新登录';
  String get version => _strings['version'] ?? '版本';
  String get copyright => _strings['copyright'] ?? 'Copyright 2025 Dochat';
  String get unbind => _strings['unbind'] ?? '解绑';
  String get bind => _strings['bind'] ?? '绑定';
  String get notBound => _strings['notBound'] ?? '未绑定';
  String get faceVerify => _strings['faceVerify'] ?? '人脸识别';
  String get faceVerifyHint => _strings['faceVerifyHint'] ?? '人脸ID（开发中）';
  String get realName => _strings['realName'] ?? '真实姓名';
  String get idNumber => _strings['idNumber'] ?? '身份证号';
  String get submitVerify => _strings['submitVerify'] ?? '提交认证';
  String get verifyPending => _strings['verifyPending'] ?? '审核中';
  String get verifyRejected => _strings['verifyRejected'] ?? '审核未通过';
  String get other => _strings['other'] ?? '其他';
  String get goldCredit => _strings['goldCredit'] ?? '金牌';
  String get silverCredit => _strings['silverCredit'] ?? '银牌';
  String get copperCredit => _strings['copperCredit'] ?? '铜牌';
  String get save => _strings['save'] ?? '保存';


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

      'sendMessage': isZh ? '发消息' : 'Send Message',
      'creditScore': isZh ? '信誉分' : 'Credit Score',
      'envMonitor': isZh ? '环境监听' : 'Environment Monitor',
      'cameraView': isZh ? '摄像头查看' : 'Camera View',
      'noGeoFences': isZh ? '暂无电子围栏' : 'No Geo-Fences',
      'addGeoFence': isZh ? '添加围栏' : 'Add Geo-Fence',
      'fenceName': isZh ? '围栏名称' : 'Fence Name',
      'latitude': isZh ? '纬度' : 'Latitude',
      'longitude': isZh ? '经度' : 'Longitude',
      'radius': isZh ? '半径' : 'Radius',
      'radiusUnit': isZh ? '米' : 'm',
      'playing': isZh ? '播放中...' : 'Playing...',
      'play': isZh ? '播放' : 'Play',
      'points': isZh ? '点' : 'pts',
      'noTrajectoryData': isZh ? '暂无轨迹数据' : 'No trajectory data',
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
      'minAgo': isZh ? '分钟前' : 'm ago',
      'hourAgo': isZh ? '小时前' : 'h ago',
      'dayAgo': isZh ? '天前' : 'd ago',
      'yesterday': isZh ? '昨天' : 'Yesterday',
      'copied': isZh ? '已复制' : 'Copied',
      'clearChat': isZh ? '清空聊天记录' : 'Clear Chat History',
      'clearChatConfirm': isZh ? '确定要清空聊天记录吗？' : 'Are you sure you want to clear chat history?',
      'dismiss': isZh ? '解除' : 'Dismiss',
      'unpin': isZh ? '取消置顶' : 'Unpin',
      'unmute': isZh ? '取消静音' : 'Unmute',
      'noMessages': isZh ? '暂无消息' : 'No messages',
      'typing': isZh ? '对方正在输入...' : 'Typing...',
      'friends': isZh ? '好友' : 'Friends',
      'groups': isZh ? '群聊' : 'Groups',
      'friendRequests': isZh ? '好友申请' : 'Friend Requests',
      'addFriend': isZh ? '添加好友' : 'Add Friend',
      'searchFriend': isZh ? '搜索好友' : 'Search Friend',
      'enterPhone': isZh ? '输入手机号' : 'Enter Phone',
      'sendRequest': isZh ? '发送好友申请' : 'Send Request',
      'accept': isZh ? '接受' : 'Accept',
      'reject': isZh ? '拒绝' : 'Reject',
      'accepted': isZh ? '已接受' : 'Accepted',
      'rejected': isZh ? '已拒绝' : 'Rejected',
      'removeFriend': isZh ? '删除好友' : 'Remove Friend',
      'removeFriendConfirm': isZh ? '确定要删除该好友吗？' : 'Are you sure you want to remove this friend?',
      'friendRequestSent': isZh ? '好友申请已发送' : 'Friend request sent',
      'alreadyFriends': isZh ? '已经是好友' : 'Already friends',
      'liveLocation': isZh ? '实时定位' : 'Live Location',
      'trajectory': isZh ? '轨迹回放' : 'Trajectory',
      'geofence': isZh ? '电子围栏' : 'Geo-Fence',
      'shareLocation': isZh ? '共享位置' : 'Share Location',
      'distance': isZh ? '距离' : 'Distance',
      'battery': isZh ? '电量' : 'Battery',
      'noPendingRequests': isZh ? '暂无好友申请' : 'No pending requests',
      'userNotFound': isZh ? '未找到该用户' : 'User not found',
      'requestMessageHint': isZh ? '你好，我想加你为好友' : 'Hi, I would like to add you as a friend',

      'square': isZh ? '广场' : 'Square',
      'recommend': isZh ? '推荐' : 'Recommend',
      
      'myFollowing': isZh ? '我的关注' : 'My Following',
      'myFollowers': isZh ? '我的粉丝' : 'My Followers',
      'reply': isZh ? '回复' : 'Reply',
      'posts_': isZh ? '动态' : 'Posts',
      'userLabel': isZh ? '用户' : 'User',
      'userIdLabel': isZh ? 'ID: {id}' : 'ID: {id}',
      'discardEdit': isZh ? '放弃编辑？' : 'Discard editing?',
      'discardEditHint': isZh ? '退出后内容不会保存' : 'Content will not be saved',
      'following': isZh ? '关注' : 'Following',
      'moments': isZh ? '动态' : 'Moments',
      'follow': isZh ? '关注' : 'Follow',
      'following_label': isZh ? '已关注' : 'Following',
      'unfollow': isZh ? '取消关注' : 'Unfollow',
      'newPost': isZh ? '发布动态' : 'New Post',
      'shareThoughts': isZh ? '分享你的想法...' : 'Share your thoughts...',
      'publish': isZh ? '发布' : 'Publish',
      'addPhotos': isZh ? '添加图片' : 'Add Photos',
      'addVideo': isZh ? '添加视频' : 'Add Video',
      'addLocation': isZh ? '添加位置' : 'Add Location',
      'locationComingSoon': isZh ? '位置功能即将上线' : 'Location feature coming soon',
      'public': isZh ? '公开' : 'Public',
      'friendsOnly': isZh ? '好友' : 'Friends',
      'private': isZh ? '私密' : 'Private',
      'expand': isZh ? '全文' : 'Expand',
      'collapse': isZh ? '收起' : 'Collapse',
      'noComments': isZh ? '暂无评论' : 'No comments',
      'comments': isZh ? '评论' : 'Comments',
      'saySomething': isZh ? '说点什么...' : 'Say something...',
      'drafts': isZh ? '草稿箱' : 'Drafts',
      'noDrafts': isZh ? '暂无草稿' : 'No drafts',
      'myPosts': isZh ? '我的动态' : 'My Posts',
      'favorites': isZh ? '收藏' : 'Favorites',
      'viewHistory': isZh ? '浏览记录' : 'View History',
      'editProfile': isZh ? '编辑资料' : 'Edit Profile',
      'noPosts': isZh ? '暂无动态' : 'No posts',
      'videoMode': isZh ? '视频模式' : 'Video Mode',
      'like': isZh ? '赞' : 'Like',
      'comment': isZh ? '评论' : 'Comment',
      'share': isZh ? '转发' : 'Share',
      'profile': isZh ? '我的' : 'Profile',
      'chats': isZh ? '聊天' : 'Chats',
      'services': isZh ? '服务' : 'Services',
      'recentlyUsed': isZh ? '最近使用' : 'Recently Used',
      'noRecent': isZh ? '暂无使用记录' : 'No recent usage',
      'serviceHub': isZh ? '服务中心' : 'Service Hub',
      'guarantee': isZh ? '担保' : 'Guarantee',
      'mall': isZh ? '商城' : 'Mall',
      'dating': isZh ? '婚恋' : 'Dating',
      'housing': isZh ? '找房' : 'Housing',
      'recruit': isZh ? '直聘' : 'Recruit',
      'emailService': isZh ? '邮箱' : 'Email',
      'shipping': isZh ? '速运' : 'Shipping',
      'homeService': isZh ? '到家' : 'Home Service',

      'settings': isZh ? '设置' : 'Settings',
      'account': isZh ? '账号' : 'Account',
      'general': isZh ? '通用' : 'General',
      'storage_label': isZh ? '存储' : 'Storage',
      'about': isZh ? '关于' : 'About',
      'realNameVerify': isZh ? '实名认证' : 'Real-Name Verify',
      'verified': isZh ? '已认证' : 'Verified',
      'unverified': isZh ? '未认证' : 'Unverified',
      'deviceManagement': isZh ? '设备管理' : 'Device Management',
      'currentDevice': isZh ? '当前设备' : 'Current Device',
      'darkMode': isZh ? '深色模式' : 'Dark Mode',
      'language': isZh ? '多语言' : 'Language',
      'paymentSettings': isZh ? '支付设置' : 'Payment Settings',
      'storageManagement': isZh ? '存储管理' : 'Storage Management',
      'clearCache': isZh ? '清除缓存' : 'Clear Cache',
      'feedback': isZh ? '帮助与反馈' : 'Help & Feedback',
      'aboutUs': isZh ? '关于我们' : 'About Us',
      'userAgreement': isZh ? '用户协议' : 'User Agreement',
      'privacyPolicy': isZh ? '隐私政策' : 'Privacy Policy',
      'deleteAccount': isZh ? '注销账号' : 'Delete Account',
      'onlineVisibility': isZh ? '在线状态' : 'Online Visibility',
      'avatarVisibility': isZh ? '头像可见' : 'Avatar Visibility',
      'bioVisibility': isZh ? '简介可见' : 'Bio Visibility',
      'messagePermission': isZh ? '消息权限' : 'Message Permission',
      'everyone': isZh ? '所有人' : 'Everyone',
      'nobody': isZh ? '无人' : 'Nobody',
      'blacklist': isZh ? '黑名单' : 'Blacklist',
      'noBlacklist': isZh ? '暂无黑名单' : 'No blacklisted users',
      'creditScoreLabel': isZh ? '信誉分' : 'Credit Score',
      'signOutMessage': isZh ? '退出后需要重新登录' : 'You will need to sign in again',
      'version': isZh ? '版本' : 'Version',
      'copyright': isZh ? 'Copyright 2025 Dochat' : 'Copyright 2025 Dochat',
      'unbind': isZh ? '解绑' : 'Unbind',
      'bind': isZh ? '绑定' : 'Bind',
      'notBound': isZh ? '未绑定' : 'Not Bound',
      'faceVerify': isZh ? '人脸识别' : 'Face Verify',
      'faceVerifyHint': isZh ? '人脸ID（开发中）' : 'Face ID (WIP)',
      'realName': isZh ? '真实姓名' : 'Real Name',
      'idNumber': isZh ? '身份证号' : 'ID Number',
      'submitVerify': isZh ? '提交认证' : 'Submit',
      'verifyPending': isZh ? '审核中' : 'Pending',
      'verifyRejected': isZh ? '审核未通过' : 'Rejected',
      'other': isZh ? '其他' : 'Other',
      'goldCredit': isZh ? '金牌' : 'Gold',
      'silverCredit': isZh ? '银牌' : 'Silver',
      'copperCredit': isZh ? '铜牌' : 'Bronze',
      'save': isZh ? '保存' : 'Save',
      'wrongPassword': isZh ? '密码错误' : 'Wrong password',
    });
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
