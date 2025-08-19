import 'package:advertising_id/advertising_id.dart';
import 'package:dima1/pages/appsflyer.dart';
import 'package:dima1/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  print('🚀 App starting...');
  WidgetsFlutterBinding.ensureInitialized();
  print('✅ WidgetsFlutterBinding initialized');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  print('✅ Orientation set');

  try {
    print('🔄 Skipping FlutterDownloader initialization for testing');
    // await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    print('✅ FlutterDownloader skipped');
  } catch (e) {
    print('❌ FlutterDownloader error: $e');
  }

  String? campaign;
  try {
    print('🔄 Initializing AppsFlyer...');
    // TODO: Replace with your actual AppsFlyer dev key
    campaign = await initAppsFlyer("YOUR_DEV_KEY_HERE");
    print('✅ AppsFlyer initialized, campaign: $campaign');
  } catch (e) {
    print('❌ AppsFlyer error: $e');
    campaign = null;
  }

  String? advertisingId;
  try {
    print('🔄 Getting advertising ID (with ATT prompt)...');
    advertisingId = await AdvertisingId.id(true);
    print('✅ Advertising ID: $advertisingId');
  } on PlatformException catch (e) {
    print('❌ PlatformException getting advertising ID: $e');
    advertisingId = null;
  } catch (e) {
    print('❌ General error getting advertising ID: $e');
    advertisingId = null;
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('advertisingId', advertisingId ?? '');
    await prefs.setString('campaign', campaign ?? '');
    print('✅ Preferences saved');
  } catch (e) {
    print('❌ Preferences error: $e');
  }

  // await NotificationService().init();
  // await NotificationService().startRandomNotifications();

  print('🎯 Running app...');
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
