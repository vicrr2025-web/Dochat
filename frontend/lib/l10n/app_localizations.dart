
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

  String get createTrade => _strings['createTrade'] ?? '创建交易';
  String get tradeList => _strings['tradeList'] ?? '交易列表';
  String get tradeDetail => _strings['tradeDetail'] ?? '交易详情';
  String get productName => _strings['productName'] ?? '商品名称';
  String get productDesc => _strings['productDesc'] ?? '商品描述';
  String get tradeAmount => _strings['tradeAmount'] ?? '交易金额';
  String get selectCounterparty => _strings['selectCounterparty'] ?? '选择交易对方';
  String get pending => _strings['pending'] ?? '待确认';
  String get confirmed => _strings['confirmed'] ?? '已确认';
  String get frozen => _strings['frozen'] ?? '已冻结';
  String get verifying => _strings['verifying'] ?? '验号中';
  String get verifyPassed => _strings['verifyPassed'] ?? '已验号';
  String get completed => _strings['completed'] ?? '已完成';
  String get cancelled => _strings['cancelled'] ?? '已关闭';
  String get disputed => _strings['disputed'] ?? '纠纷中';
  String get confirmTrade => _strings['confirmTrade'] ?? '确认交易';
  String get freezeFunds => _strings['freezeFunds'] ?? '冻结资金';
  String get initiateVerify => _strings['initiateVerify'] ?? '发起验号';
  String get releaseFunds => _strings['releaseFunds'] ?? '确认收货';
  String get initiateDispute => _strings['initiateDispute'] ?? '发起纠纷';
  String get juryVoting => _strings['juryVoting'] ?? '陪审团投票';
  String get juryVerdict => _strings['juryVerdict'] ?? '陪审团裁决';
  String get chatWithCounterparty => _strings['chatWithCounterparty'] ?? '联系对方';
  String get noTrades => _strings['noTrades'] ?? '暂无交易';
  String get createTradeTitle => _strings['createTradeTitle'] ?? '创建交易';
  String get buyer => _strings['buyer'] ?? '买方';
  String get seller => _strings['seller'] ?? '卖方';
  String get disputeDetail => _strings['disputeDetail'] ?? '纠纷详情';
  String get viewDispute => _strings['viewDispute'] ?? '查看纠纷';
  String get columnReason => _strings['columnReason'] ?? '纠纷原因';
  String get initiator => _strings['initiator'] ?? '发起方';
  String get verifyStatus => _strings['verifyStatus'] ?? '验证状态';
  String get votes => _strings['votes'] ?? '票';
  String get all => _strings['all'] ?? '全部';
  String get active => _strings['active'] ?? '进行中';
  String get closed => _strings['closed'] ?? '已关闭';

  // ======== M8 商城 ========
  String get mallTab => _strings['mallTab'] ?? '商城';
  String get farmProducts => _strings['farmProducts'] ?? '农产品';
  String get factoryDirect => _strings['factoryDirect'] ?? '工厂直供';
  String get idleItems => _strings['idleItems'] ?? '闲置';
  String get publishProduct => _strings['publishProduct'] ?? '发布商品';
  String get productTitle => _strings['productTitle'] ?? '商品标题';
  String get productPrice => _strings['productPrice'] ?? '商品价格';
  String get productCategory => _strings['productCategory'] ?? '商品分类';
  String get productImages => _strings['productImages'] ?? '商品图片';
  String get addToCart => _strings['addToCart'] ?? '加入购物车';
  String get myCart => _strings['myCart'] ?? '我的购物车';
  String get cartEmpty => _strings['cartEmpty'] ?? '购物车空空如也';
  String get checkout => _strings['checkout'] ?? '去结算';
  String get selectAll => _strings['selectAll'] ?? '全选';
  String get totalAmount => _strings['totalAmount'] ?? '合计';
  String get myOrders => _strings['myOrders'] ?? '我的订单';
  String get toPayStatus => _strings['toPayStatus'] ?? '待付款';
  String get toShipStatus => _strings['toShipStatus'] ?? '待发货';
  String get toReceiveStatus => _strings['toReceiveStatus'] ?? '待收货';
  String get toReviewStatus => _strings['toReviewStatus'] ?? '待评价';
  String get payNow => _strings['payNow'] ?? '立即支付';
  String get shipOrder => _strings['shipOrder'] ?? '发货';
  String get confirmReceipt => _strings['confirmReceipt'] ?? '确认收货';
  String get trackingNo => _strings['trackingNo'] ?? '物流单号';
  String get applyRefund => _strings['applyRefund'] ?? '申请退款';
  String get refundReason => _strings['refundReason'] ?? '退款原因';
  String get myFavorites => _strings['myFavorites'] ?? '我的收藏';
  String get addFavorite => _strings['addFavorite'] ?? '收藏';
  String get removeFavorite => _strings['removeFavorite'] ?? '取消收藏';
  String get contactSellerLabel => _strings['contactSellerLabel'] ?? '联系卖家';
  String get shopInfo => _strings['shopInfo'] ?? '店铺信息';
  String get openShop => _strings['openShop'] ?? '开店';
  String get shopName => _strings['shopName'] ?? '店铺名称';
  String get recycleEstimate => _strings['recycleEstimate'] ?? '估价';
  String get submitRecycle => _strings['submitRecycle'] ?? '提交回收';
  String get relistItem => _strings['relistItem'] ?? '重新发布';
  String get writeReview => _strings['writeReview'] ?? '写评价';
  String get rating => _strings['rating'] ?? '评分';
  String get browseHistory => _strings['browseHistory'] ?? '浏览历史';
  String get clearHistory => _strings['clearHistory'] ?? '清空历史';
  String get coupons => _strings['coupons'] ?? '优惠券';
  String get claimCoupon => _strings['claimCoupon'] ?? '领取';
  String get myCoupons => _strings['myCoupons'] ?? '我的优惠券';
  String get noProductsHint => _strings['noProductsHint'] ?? '暂无商品';
  String get noOrdersHint => _strings['noOrdersHint'] ?? '暂无订单';

  String get datingTab => _strings['datingTab'] ?? '婚恋';
  String get gender => _strings['gender'] ?? '性别';
  String get maleLabel => _strings['maleLabel'] ?? '男士';
  String get femaleLabel => _strings['femaleLabel'] ?? '女士';
  String get birthdayLabel => _strings['birthdayLabel'] ?? '生日';
  String get heightLabel => _strings['heightLabel'] ?? '身高';
  String get educationLabel => _strings['educationLabel'] ?? '学历';
  String get incomeLabel => _strings['incomeLabel'] ?? '月收入';
  String get maritalStatusLabel => _strings['maritalStatusLabel'] ?? '婚姻状况';
  String get tagsLabel => _strings['tagsLabel'] ?? '标签';
  String get aboutMeLabel => _strings['aboutMeLabel'] ?? '关于我';
  String get aiGenerate => _strings['aiGenerate'] ?? 'AI 生成';
  String get matchRecommend => _strings['matchRecommend'] ?? '推荐';
  String get likeDating => _strings['likeDating'] ?? '喜欢';
  String get superLikeLabel => _strings['superLikeLabel'] ?? '超级喜欢';
  String get matchedLabel => _strings['matchedLabel'] ?? '匹配成功';
  String get noteLabel => _strings['noteLabel'] ?? '小纸条';
  String get sendNote => _strings['sendNote'] ?? '发小纸条';
  String get datingFeed => _strings['datingFeed'] ?? '缘分圈';
  String get publishFeed => _strings['publishFeed'] ?? '发布动态';
  String get liveStream => _strings['liveStream'] ?? '直播';
  String get startLive => _strings['startLive'] ?? '开播';
  String get endLive => _strings['endLive'] ?? '结束直播';
  String get sendGift => _strings['sendGift'] ?? '送礼物';
  String get charmValue => _strings['charmValue'] ?? '魅力值';
  String get withdrawLabel => _strings['withdrawLabel'] ?? '提现';
  String get loveCoin => _strings['loveCoin'] ?? '珍爱币';
  String get rechargeLabel => _strings['rechargeLabel'] ?? '充值';
  String get vipMember => _strings['vipMember'] ?? 'VIP 会员';
  String get superBoost => _strings['superBoost'] ?? '超级推荐';
  String get realAuth => _strings['realAuth'] ?? '实名认证';
  String get workAuth => _strings['workAuth'] ?? '工作认证';
  String get eduAuth => _strings['eduAuth'] ?? '学历认证';
  String get noRecommend => _strings['noRecommend'] ?? '暂无推荐';
  String get houseTab => _strings['houseTab'] ?? '找房';
  String get newHouse => _strings['newHouse'] ?? '新房';
  String get secondHouse => _strings['secondHouse'] ?? '二手房';
  String get rentHouse => _strings['rentHouse'] ?? '租房';
  String get commercialHouse => _strings['commercialHouse'] ?? '商业地产';
  String get houseType => _strings['houseType'] ?? '房屋类型';
  String get houseLayout => _strings['houseLayout'] ?? '户型';
  String get houseArea => _strings['houseArea'] ?? '面积';
  String get houseFloor => _strings['houseFloor'] ?? '楼层';
  String get houseDirection => _strings['houseDirection'] ?? '朝向';
  String get houseDecoration => _strings['houseDecoration'] ?? '装修';
  String get housePrice => _strings['housePrice'] ?? '价格';
  String get totalPriceLabel => _strings['totalPriceLabel'] ?? '总价';
  String get unitPriceLabel => _strings['unitPriceLabel'] ?? '单价';
  String get monthlyRent => _strings['monthlyRent'] ?? '月租';
  String get publishHouse => _strings['publishHouse'] ?? '发布房源';
  String get publishHouseTitle => _strings['publishHouseTitle'] ?? '发布房源';
  String get appointmentViewing => _strings['appointmentViewing'] ?? '预约看房';
  String get appointmentTime => _strings['appointmentTime'] ?? '预约时间';
  String get freeBus => _strings['freeBus'] ?? '免费专车';
  String get communityInfo => _strings['communityInfo'] ?? '小区信息';
  String get communityReview => _strings['communityReview'] ?? '小区评测';
  String get ownerService => _strings['ownerService'] ?? '房东服务';
  String get houseValuation => _strings['houseValuation'] ?? '房屋估价';
  String get quickSell => _strings['quickSell'] ?? '快速卖房';
  String get sellVip => _strings['sellVip'] ?? '速卖VIP';
  String get renovationService => _strings['renovationService'] ?? '装修服务';
  String get renovationEstimate => _strings['renovationEstimate'] ?? '装修估价';
  String get mortgageCalc => _strings['mortgageCalc'] ?? '房贷计算';
  String get taxCalc => _strings['taxCalc'] ?? '税费计算';
  String get downPayment => _strings['downPayment'] ?? '首付';
  String get loanRate => _strings['loanRate'] ?? '利率';
  String get loanYears => _strings['loanYears'] ?? '年限';
  String get monthlyPayment => _strings['monthlyPayment'] ?? '月供';
  String get totalInterest => _strings['totalInterest'] ?? '总利息';
  String get microChat => _strings['microChat'] ?? '微聊';
  String get noHouseHint => _strings['noHouseHint'] ?? '暂无房源';
  String get contactLandlord => _strings['contactLandlord'] ?? '联系房东';
  String get houseTags => _strings['houseTags'] ?? '标签';
  String get aiTitle => _strings['aiTitle'] ?? 'AI 生成标题';
  String get messagesLabel => _strings['messagesLabel'] ?? '消息';




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

      'createTrade': isZh ? '创建交易' : 'Create Trade',
      'tradeList': isZh ? '交易列表' : 'Trade List',
      'tradeDetail': isZh ? '交易详情' : 'Trade Detail',
      'productName': isZh ? '商品名称' : 'Product Name',
      'productDesc': isZh ? '商品描述' : 'Product Description',
      'tradeAmount': isZh ? '交易金额' : 'Trade Amount',
      'selectCounterparty': isZh ? '选择交易对方' : 'Select Counterparty',
      'pending': isZh ? '待确认' : 'Pending',
      'confirmed': isZh ? '已确认' : 'Confirmed',
      'frozen': isZh ? '已冻结' : 'Frozen',
      'verifying': isZh ? '验号中' : 'Verifying',
      'verifyPassed': isZh ? '已验号' : 'Verified',
      'completed': isZh ? '已完成' : 'Completed',
      'cancelled': isZh ? '已关闭' : 'Cancelled',
      'disputed': isZh ? '纠纷中' : 'Disputed',
      'confirmTrade': isZh ? '确认交易' : 'Confirm Trade',
      'freezeFunds': isZh ? '冻结资金' : 'Freeze Funds',
      'initiateVerify': isZh ? '发起验号' : 'Initiate Verify',
      'releaseFunds': isZh ? '确认收货' : 'Release Funds',
      'initiateDispute': isZh ? '发起纠纷' : 'Initiate Dispute',
      'juryVoting': isZh ? '陪审团投票' : 'Jury Voting',
      'juryVerdict': isZh ? '陪审团裁决' : 'Jury Verdict',
      'chatWithCounterparty': isZh ? '联系对方' : 'Chat with Counterparty',
      'noTrades': isZh ? '暂无交易' : 'No Trades',
      'createTradeTitle': isZh ? '创建交易' : 'Create Trade',
      'buyer': isZh ? '买方' : 'Buyer',
      'seller': isZh ? '卖方' : 'Seller',
      'disputeDetail': isZh ? '纠纷详情' : 'Dispute Detail',
      'viewDispute': isZh ? '查看纠纷' : 'View Dispute',
      'columnReason': isZh ? '纠纷原因' : 'Reason',
      'initiator': isZh ? '发起方' : 'Initiator',
      'verifyStatus': isZh ? '验证状态' : 'Verify Status',
      'votes': isZh ? '票' : 'Votes',
      'all': isZh ? '全部' : 'All',
      'active': isZh ? '进行中' : 'Active',
      'closed': isZh ? '已关闭' : 'Closed',
      'wrongPassword': isZh ? '密码错误' : 'Wrong password',

      'mallTab': isZh ? '商城' : 'Mall',
      'farmProducts': isZh ? '农产品' : 'Farm Products',
      'factoryDirect': isZh ? '工厂直供' : 'Factory Direct',
      'idleItems': isZh ? '闲置' : 'Idle Items',
      'publishProduct': isZh ? '发布商品' : 'Publish Product',
      'productTitle': isZh ? '商品标题' : 'Product Title',
      'productPrice': isZh ? '商品价格' : 'Product Price',
      'productCategory': isZh ? '商品分类' : 'Category',
      'productImages': isZh ? '商品图片' : 'Images',
      'addToCart': isZh ? '加入购物车' : 'Add to Cart',
      'myCart': isZh ? '我的购物车' : 'My Cart',
      'cartEmpty': isZh ? '购物车空空如也' : 'Cart is empty',
      'checkout': isZh ? '去结算' : 'Checkout',
      'selectAll': isZh ? '全选' : 'Select All',
      'totalAmount': isZh ? '合计' : 'Total',
      'myOrders': isZh ? '我的订单' : 'My Orders',
      'toPayStatus': isZh ? '待付款' : 'To Pay',
      'toShipStatus': isZh ? '待发货' : 'To Ship',
      'toReceiveStatus': isZh ? '待收货' : 'To Receive',
      'toReviewStatus': isZh ? '待评价' : 'To Review',
      'payNow': isZh ? '立即支付' : 'Pay Now',
      'shipOrder': isZh ? '发货' : 'Ship',
      'confirmReceipt': isZh ? '确认收货' : 'Confirm Receipt',
      'trackingNo': isZh ? '物流单号' : 'Tracking No.',
      'applyRefund': isZh ? '申请退款' : 'Apply Refund',
      'refundReason': isZh ? '退款原因' : 'Refund Reason',
      'myFavorites': isZh ? '我的收藏' : 'My Favorites',
      'addFavorite': isZh ? '收藏' : 'Add Favorite',
      'removeFavorite': isZh ? '取消收藏' : 'Remove Favorite',
      'contactSellerLabel': isZh ? '联系卖家' : 'Contact Seller',
      'shopInfo': isZh ? '店铺信息' : 'Shop Info',
      'openShop': isZh ? '开店' : 'Open Shop',
      'shopName': isZh ? '店铺名称' : 'Shop Name',
      'recycleEstimate': isZh ? '估价' : 'Estimate',
      'submitRecycle': isZh ? '提交回收' : 'Submit Recycle',
      'relistItem': isZh ? '重新发布' : 'Relist',
      'writeReview': isZh ? '写评价' : 'Write Review',
      'rating': isZh ? '评分' : 'Rating',
      'browseHistory': isZh ? '浏览历史' : 'Browse History',
      'clearHistory': isZh ? '清空历史' : 'Clear History',
      'coupons': isZh ? '优惠券' : 'Coupons',
      'claimCoupon': isZh ? '领取' : 'Claim',
      'myCoupons': isZh ? '我的优惠券' : 'My Coupons',
      'noProductsHint': isZh ? '暂无商品' : 'No products',
      'datingTab': isZh ? '婚恋' : 'Dating',
      'editProfile': isZh ? '编辑资料' : 'Edit Profile',
      'gender': isZh ? '性别' : 'Gender',
      'maleLabel': isZh ? '男士' : 'Male',
      'femaleLabel': isZh ? '女士' : 'Female',
      'birthdayLabel': isZh ? '生日' : 'Birthday',
      'heightLabel': isZh ? '身高' : 'Height',
      'educationLabel': isZh ? '学历' : 'Education',
      'incomeLabel': isZh ? '月收入' : 'Income',
      'maritalStatusLabel': isZh ? '婚姻状况' : 'Marital Status',
      'tagsLabel': isZh ? '标签' : 'Tags',
      'aboutMeLabel': isZh ? '关于我' : 'About Me',
      'aiGenerate': isZh ? 'AI 生成' : 'AI Generate',
      'matchRecommend': isZh ? '推荐' : 'Recommendations',
      'likeDating': isZh ? '喜欢' : 'Like',
      'superLikeLabel': isZh ? '超级喜欢' : 'Super Like',
      'matchedLabel': isZh ? '匹配成功' : 'Matched',
      'noteLabel': isZh ? '小纸条' : 'Note',
      'sendNote': isZh ? '发小纸条' : 'Send Note',
      'datingFeed': isZh ? '缘分圈' : 'Moments',
      'publishFeed': isZh ? '发布动态' : 'Post',
      'liveStream': isZh ? '直播' : 'Live',
      'startLive': isZh ? '开播' : 'Go Live',
      'endLive': isZh ? '结束直播' : 'End Live',
      'sendGift': isZh ? '送礼物' : 'Send Gift',
      'charmValue': isZh ? '魅力值' : 'Charm',
      'withdrawLabel': isZh ? '提现' : 'Withdraw',
      'loveCoin': isZh ? '珍爱币' : 'Love Coins',
      'rechargeLabel': isZh ? '充值' : 'Recharge',
      'vipMember': isZh ? 'VIP 会员' : 'VIP Member',
      'superBoost': isZh ? '超级推荐' : 'Super Boost',
      'realAuth': isZh ? '实名认证' : 'ID Verify',
      'workAuth': isZh ? '工作认证' : 'Work Verify',
      'eduAuth': isZh ? '学历认证' : 'Edu Verify',
      'noRecommend': isZh ? '暂无推荐' : 'No Recommendations',
      'houseTab': isZh ? '找房' : 'Housing',
      'newHouse': isZh ? '新房' : 'New Homes',
      'secondHouse': isZh ? '二手房' : 'Resale',
      'rentHouse': isZh ? '租房' : 'Rent',
      'commercialHouse': isZh ? '商业地产' : 'Commercial',
      'houseType': isZh ? '房屋类型' : 'Type',
      'houseLayout': isZh ? '户型' : 'Layout',
      'houseArea': isZh ? '面积' : 'Area',
      'houseFloor': isZh ? '楼层' : 'Floor',
      'houseDirection': isZh ? '朝向' : 'Direction',
      'houseDecoration': isZh ? '装修' : 'Decoration',
      'housePrice': isZh ? '价格' : 'Price',
      'totalPriceLabel': isZh ? '总价' : 'Total Price',
      'unitPriceLabel': isZh ? '单价' : 'Unit Price',
      'monthlyRent': isZh ? '月租' : 'Monthly Rent',
      'publishHouse': isZh ? '发布房源' : 'Publish',
      'publishHouseTitle': isZh ? '发布房源' : 'Publish Listing',
      'appointmentViewing': isZh ? '预约看房' : 'Book Viewing',
      'appointmentTime': isZh ? '预约时间' : 'Time',
      'freeBus': isZh ? '免费专车' : 'Free Shuttle',
      'communityInfo': isZh ? '小区信息' : 'Community',
      'communityReview': isZh ? '小区评测' : 'Review',
      'ownerService': isZh ? '房东服务' : 'Owner Services',
      'houseValuation': isZh ? '房屋估价' : 'Valuation',
      'quickSell': isZh ? '快速卖房' : 'Quick Sell',
      'sellVip': isZh ? '速卖VIP' : 'Sell VIP',
      'renovationService': isZh ? '装修服务' : 'Renovation',
      'renovationEstimate': isZh ? '装修估价' : 'Estimate',
      'mortgageCalc': isZh ? '房贷计算' : 'Mortgage',
      'taxCalc': isZh ? '税费计算' : 'Tax Calc',
      'downPayment': isZh ? '首付' : 'Down Payment',
      'loanRate': isZh ? '利率' : 'Rate',
      'loanYears': isZh ? '年限' : 'Years',
      'monthlyPayment': isZh ? '月供' : 'Monthly',
      'totalInterest': isZh ? '总利息' : 'Total Interest',
      'microChat': isZh ? '微聊' : 'Chat',
      'noHouseHint': isZh ? '暂无房源' : 'No listings',
      'contactLandlord': isZh ? '联系房东' : 'Contact',
      'houseTags': isZh ? '标签' : 'Tags',
      'aiTitle': isZh ? 'AI 生成标题' : 'AI Title',
      'messagesLabel': isZh ? '消息' : 'Messages',
      'noOrdersHint': isZh ? '暂无订单' : 'No orders',

    });
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
