import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/auth_provider.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/providers/friend_provider.dart';
import 'package:dochat_app/providers/location_provider.dart';
import 'package:dochat_app/providers/post_provider.dart';
import 'package:dochat_app/pages/auth/splash_page.dart';

void main() {
  runApp(const DochatApp());
}

class DochatApp extends StatelessWidget {
  const DochatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => FriendProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Dochat',
        theme: const CupertinoThemeData(
          primaryColor: Color(0xFF007AFF),
          scaffoldBackgroundColor: Color(0xFFF2F2F7),
          barBackgroundColor: Color.fromRGBO(242, 242, 247, 0.8),
          textTheme: CupertinoTextThemeData(
            primaryColor: Color(0xFF1C1C1E),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh'),
          Locale('en'),
        ],
        locale: const Locale('zh'),
        home: const SplashPage(),
      ),
    );
  }
}
