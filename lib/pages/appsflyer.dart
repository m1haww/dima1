import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes the AppsFlyer SDK and handles conversion data according to v6.17.1
Future<String?> initAppsFlyer(String devKey) async {
  if (devKey.isEmpty || devKey == "2tHe6DoTpdH6Y53bBagh8N") {
    print('⚠️ AppsFlyer dev key not provided, skipping initialization');
    return null;
  }

  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: devKey,
    showDebug: true, // Enable for debugging
    timeToWaitForATTUserAuthorization: 60, // Wait for ATT prompt
  );

  final AppsflyerSdk appsFlyer = AppsflyerSdk(options);

  try {
    // Get AppsFlyer UID
    final deviceID = await appsFlyer.getAppsFlyerUID();
    print('🔵 AppsFlyer UID: $deviceID');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId', deviceID ?? '2tHe6DoTpdH6Y53bBagh8N');

    final Completer<String?> completer = Completer();

    // Set up conversion data callback (using callbacks instead of streams per v6.x)
    appsFlyer.onInstallConversionData((res) {
      print('🔵 Install conversion data: $res');
      final payload = res['payload'] as Map<String, dynamic>?;
      final campaign = payload?['campaign'] as String?;
      print('🔵 Campaign from conversion data: $campaign');
      if (!completer.isCompleted) {
        completer.complete(campaign);
      }
    });

    // Set up app open attribution callback
    appsFlyer.onAppOpenAttribution((res) {
      print('🔵 App open attribution: $res');
    });

    // Initialize SDK
    await appsFlyer.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );

    print('✅ AppsFlyer SDK initialized successfully');

    // Wait for conversion data with timeout
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        print('⏰ AppsFlyer conversion data timeout, continuing...');
        return null;
      },
    );
  } catch (e) {
    print('❌ AppsFlyer initialization error: $e');
    return null;
  }
}
