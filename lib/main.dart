import 'package:advertising_id/advertising_id.dart';
import 'package:dima1/pages/appsflyer.dart';
import 'package:dima1/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  final campaign = await initAppsFlyer("");

  final advertisingId = await AdvertisingId.id(true);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('advertisingId', advertisingId ?? '');
  await prefs.setString('campaign', campaign ?? '');

  // await NotificationService().init();
  // await NotificationService().startRandomNotifications();

  runApp(ProviderScope(child: const FarmRoadApp()));
}

class FarmRoadApp extends StatelessWidget {
  const FarmRoadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Road - Farmer\'s Path',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Farm green
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
